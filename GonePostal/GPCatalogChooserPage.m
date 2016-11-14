//
//  GPCatalogChooserPage.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogChooserPage.h"
#import "GPAddStampController.h"
#import "GPDocument.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "GPCatalog.h"
#import "GPCatalogDetail.h"
#import "GPCustomSearch.h"
#import "AlternateCatalog.h"
#import "AlternateCatalogName.h"

@interface GPCatalogChooserPage ()
@property (strong, nonatomic) GPAddStampController * parentController;

@property (weak, nonatomic) IBOutlet NSButton * changeFiltersButton;
@property (weak, nonatomic) IBOutlet NSTableView * gpCatalogTable;

@property (strong, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (weak, nonatomic) IBOutlet NSPopUpButton * gotoPopup;
@property (weak, nonatomic) IBOutlet NSTextField * gotoField;

@property (strong, nonatomic) NSPopover * catalogDetailPopover;
@property (strong, nonatomic) GPCatalogDetail * catalogDetail;

@property (strong, nonatomic) GPDocument * doc;

@property (strong, nonatomic) NSPredicate * subBasePredicate;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;
@end

@implementation GPCatalogChooserPage

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate parentController:(id)parentController{
    
    self = [super initWithNibName:@"GPCatalogChooserPage" bundle:nil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = self.doc.managedObjectContext;
        
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _filtersPredicate = filtersPredicate;
        
        _parentController = parentController;
        
        // Rebuild the query so as NOT to contain looks-like.
        NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
        [predicateArray addObject:[NSPredicate predicateWithFormat:BASE_GP_CATALOG_QUERY]];
        if (countriesPredicate) [predicateArray addObject:countriesPredicate];
        if (sectionsPredicate) [predicateArray addObject:sectionsPredicate];
        if (filtersPredicate) [predicateArray addObject:filtersPredicate];
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
        
        // Create the sort descripors
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        _gpCatalogSortDescriptors = @[catalogNumberSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:NO];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:NO];
        _filterSearchController = [[GPFilterSearch alloc] initWithPredicate:filtersPredicate];
        _subvarietySearchController = [[GPSubvarietySearch alloc] initWithPredicate:nil forStamp:NO];
        
        // Initialize the datalog detail popover.
        _catalogDetail = [[GPCatalogDetail alloc] initWithManagedObjectContext:self.managedObjectContext];
        _catalogDetailPopover = [[NSPopover alloc] init];
        _catalogDetailPopover.contentViewController = self.catalogDetail;
        _catalogDetailPopover.behavior = NSPopoverBehaviorTransient;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Place the AssistedSearch views into panels which will be launched as sheets.
    self.countrySearchController.panel = [[NSPanel alloc] initWithContentRect:self.countrySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countrySearchController.panel setContentView:self.countrySearchController.view];
    
    self.sectionSearchController.panel = [[NSPanel alloc] initWithContentRect:self.sectionSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionSearchController.panel setContentView:self.sectionSearchController.view];
    
    self.filterSearchController.panel = [[NSPanel alloc] initWithContentRect:self.filterSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.filterSearchController.panel setContentView:self.filterSearchController.view];
    
    self.subvarietySearchController.panel = [[NSPanel alloc] initWithContentRect:self.subvarietySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.subvarietySearchController.panel setContentView:self.subvarietySearchController.view];
    
    // Set the active filter search.
    [self.changeFiltersButton setTitle:self.filterSearchController.filtersSelected];
    
    self.currSearch = self.assistedSearch.predicate;
    [self queryGPCatalog];
}

- (void)setSelectedLooksLike:(LooksLike *)selectedLooksLike {
    _selectedLooksLike = selectedLooksLike;

    // Rebuild the current search to include the looks-like filter.
    [self updateCurrentSearch];
}

- (void)queryGPCatalog {
    [self.gpCatalogController setFetchPredicate:self.currSearch];
    [self.gpCatalogController fetch:self];
}

// Update the current search based on the three saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:4];
    [predicateArray addObject:[NSPredicate predicateWithFormat:BASE_GP_CATALOG_QUERY]];
    
    if (self.countrySearchController.predicate != nil) {
        [predicateArray addObject:self.countrySearchController.predicate];
    }
    
    if (self.sectionSearchController.predicate != nil) {
        [predicateArray addObject:self.sectionSearchController.predicate];
    }
    
    if (self.filterSearchController.predicate != nil) {
        [predicateArray addObject:self.filterSearchController.predicate];
    }
    
    if (self.selectedLooksLike != nil) {
        //NSLog(@"looksLike.name like %@", self.selectedLooksLike.name);
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"any looksLike.name like %@", self.selectedLooksLike.name]];
    }
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.assistedSearch.predicate = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    [self.doc saveInPlace];
    
    // Refresh the active filter search.
    [self.changeFiltersButton setTitle:self.filterSearchController.filtersSelected];
    
    // Refetch the GP Catalog Data.
    self.currSearch = self.assistedSearch.predicate;
    [self queryGPCatalog];
}

- (void)updateSubvarietiesSearch {
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
    [predicateArray addObject:self.subBasePredicate];
    
    if (self.filterSearchController.predicate != nil) {
        [predicateArray addObject:self.filterSearchController.predicate];
    }
    
    if (self.subvarietySearchController.predicate != nil) {
        [predicateArray addObject:self.subvarietySearchController.predicate];
    }
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.subvarietiesSearch = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.subvarietiesSearch = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    self.currSearch = self.subvarietiesSearch;
    [self queryGPCatalog];
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField * textField = aNotification.object;
    
    if ([textField isEqualTo:self.gotoField]) {
        NSArray * entries = self.gpCatalogController.arrangedObjects;
        NSInteger searchType = [[self.gotoPopup selectedItem] tag];
        NSString * typedValue = self.gotoField.stringValue;
        
        NSUInteger foundEntryRow = 0;
        NSRange findOP = {NSNotFound, 0};
        
        for (NSUInteger row=0; row < [entries count]; row++) {
            GPCatalog * entry = entries[row];
            
            if (searchType == 1) {
                findOP = [entry.gp_catalog_number rangeOfString:typedValue];
            }
            else if (searchType == 2) {
                NSString * altCatalogNumber;
                
                for (AlternateCatalog * altCatalog in entry.alternateCatalogs) {
                    if ([altCatalog.alternateCatalogName.alternate_catalog_name isEqualToString:entry.defaultCatalogName.alternate_catalog_name]) {
                        altCatalogNumber = altCatalog.alternate_catalog_number;
                        break;
                    }
                }
                
                findOP = [altCatalogNumber rangeOfString:typedValue];
            }
            
            if (findOP.length > 0) {
                foundEntryRow = row;
                break;
            }
        }
        
        NSIndexSet * changeToSelection = [NSIndexSet indexSetWithIndex:foundEntryRow];
        [self.gpCatalogTable selectRowIndexes:changeToSelection byExtendingSelection:NO];
        [self.gpCatalogTable scrollRowToVisible:foundEntryRow];
    }
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    [self.view.window beginSheet:self.countrySearchController.panel completionHandler:^(NSModalResponse returnCode) {
        if (self.currMajorVariety)
            [self updateSubvarietiesSearch];
        else
            [self updateCurrentSearch];
        [self.view.window endSheet:self.countrySearchController.panel];
    }];
    
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    [self.view.window beginSheet:self.sectionSearchController.panel completionHandler:^(NSModalResponse returnCode) {
        if (self.currMajorVariety)
            [self updateSubvarietiesSearch];
        else
            [self updateCurrentSearch];
        [self.view.window endSheet:self.sectionSearchController.panel];
    }];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    [self.view.window beginSheet:self.filterSearchController.panel completionHandler:^(NSModalResponse returnCode) {
        if (self.currMajorVariety)
            [self updateSubvarietiesSearch];
        else
            [self updateCurrentSearch];
        [self.view.window endSheet:self.filterSearchController.panel];
    }];
}

- (IBAction)openSubvarietySearchPanel:(id)sender {
    [self.view.window beginSheet:self.subvarietySearchController.panel completionHandler:^(NSModalResponse returnCode) {
        if (self.currMajorVariety)
            [self updateSubvarietiesSearch];
        else
            [self updateCurrentSearch];
        [self.view.window endSheet:self.subvarietySearchController.panel];
    }];
}

- (IBAction)viewSubvarieties:(id)sender {
    NSInteger row = [self.gpCatalogTable rowForView:sender];
    GPCatalog * theMajorVariety = self.gpCatalogController.arrangedObjects[row];
    
    if (theMajorVariety != nil && (theMajorVariety.subvarieties.count > 0)) {
        self.subBasePredicate = [NSPredicate predicateWithFormat:@"majorVariety.gp_catalog_number like %@", theMajorVariety.gp_catalog_number];
        
        [self updateSubvarietiesSearch];
        
        // Set the selection to the first subvariety.
        [self.gpCatalogController setSelectionIndex:0];
        
        self.currMajorVariety = theMajorVariety;
    }
}

- (IBAction)closeSubvarieties:(id)sender {
    // Restore the current search.
    self.currSearch = self.assistedSearch.predicate;
    [self queryGPCatalog];
    
    [self.gpCatalogController setSelectedObjects:@[self.currMajorVariety]];
    NSUInteger indexOfMajorVariety = self.gpCatalogController.selectionIndex;
    
    // Make sure the selection is visable.
    [self.gpCatalogTable scrollRowToVisible:indexOfMajorVariety];
    self.currMajorVariety = nil;
}

- (IBAction)showCatalogDetail:(NSButton *)sender {
    NSInteger selectedRow = [self.gpCatalogTable rowForView:sender];
    GPCatalog * gpCatalog = self.gpCatalogController.arrangedObjects[selectedRow];
    [self.catalogDetail setGpCatalog:gpCatalog];
    
    [self.catalogDetailPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:selectedRow];
}

- (IBAction)editCustomSearch:(id)sender {
    GPCustomSearch * customSearchController = [[GPCustomSearch alloc] initWithStoredSearchIdentifier:@(CUSTOM_GP_CATALOG_SEARCH_ID)];
    [self.doc addWindowController:customSearchController];
    [customSearchController.window makeKeyAndOrderFront:sender];
}

- (IBAction)executeCustomSearch:(id)sender {
    if (!self.currCustomSearch || !self.currCustomSearch.predicate) return;
    
    self.currSearch = self.currCustomSearch.predicate;
    [self queryGPCatalog];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger selectedRow = self.gpCatalogTable.selectedRow;
    self.selectedGPCatalog = self.gpCatalogController.arrangedObjects[selectedRow];
    [self.parentController setSelectedGPCatalog:self.selectedGPCatalog];
}

@end
