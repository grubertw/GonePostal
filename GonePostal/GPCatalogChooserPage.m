//
//  GPCatalogChooserPage.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogChooserPage.h"
#import "GPDocument.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "GPCatalog.h"
#import "GPCatalogDetail.h"
#import "GPCustomSearch.h"

@interface GPCatalogChooserPage ()
@property (weak, nonatomic) IBOutlet NSButton * changeFiltersButton;
@property (weak, nonatomic) IBOutlet NSTableView * gpCatalogTable;

@property (strong, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (strong, nonatomic) NSPopover * catalogDetailPopover;
@property (strong, nonatomic) GPCatalogDetail * catalogDetail;

@property (strong, nonatomic) GPDocument * doc;

@end

@implementation GPCatalogChooserPage

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
        [predicateArray addObject:[NSPredicate predicateWithFormat:@"looksLike.name like %@", self.selectedLooksLike.name]];
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

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate {
    
    self = [super initWithNibName:@"GPCatalogChooserPage" bundle:nil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = self.doc.managedObjectContext;
        
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _filtersPredicate = filtersPredicate;
        
        // Rebuild the query so as NOT to contain looks-like.
        NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
        [predicateArray addObject:[NSPredicate predicateWithFormat:BASE_GP_CATALOG_QUERY]];
        if (countriesPredicate) [predicateArray addObject:countriesPredicate];
        if (sectionsPredicate) [predicateArray addObject:sectionsPredicate];
        if (filtersPredicate) [predicateArray addObject:filtersPredicate];
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
        
        // Create the sort descripors
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        _gpCatalogSortDescriptors = @[gpCountrySort, groupSort, catalogNumberSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:NO];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:NO];
        _filterSearchController = [[GPFilterSearch alloc] initWithPredicate:filtersPredicate];
        
        // Initialize the datalog detail popover.
        _catalogDetail = [[GPCatalogDetail alloc] initWithManagedObjectContext:self.managedObjectContext];
        _catalogDetailPopover = [[NSPopover alloc] init];
        _catalogDetailPopover.contentViewController = self.catalogDetail;
        _catalogDetailPopover.appearance = NSPopoverAppearanceMinimal;
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

- (IBAction)openCountriesSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.countrySearchController.panel modalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.sectionSearchController.panel modalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.filterSearchController.panel modalForWindow:self.view.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)showCatalogDetail:(NSButton *)sender {
    NSInteger selectedRow = [self.gpCatalogTable rowForView:sender];
    GPCatalog * gpCatalog = self.gpCatalogController.arrangedObjects[selectedRow];
    [self.catalogDetail setGpCatalog:gpCatalog];
    
    [self.catalogDetailPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:selectedRow];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [self updateCurrentSearch];
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
}

@end
