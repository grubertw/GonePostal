//
//  GPCatalogPictureSelector.m
//  GonePostal
//
//  Created by Travis Gruber on 6/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogPictureSelector.h"
#import "GPDocument.h"
#import "AlternateCatalog.h"
#import "AlternateCatalogName.h"

static NSString * CHOOSE_PICTURE_FROM_CATALOG = @"Copy Picture from Catalog Entry";
static NSString * CHOOSE_GPID_FROM_CATALOG = @"Insert a Catalog Entry";

@interface GPCatalogPictureSelector ()
@property (strong, nonatomic) GPDocument * doc;

@property (weak, nonatomic) IBOutlet NSBox * gpCatalogBox;

@property (weak, nonatomic) IBOutlet NSTableView * gpCatalogTable;
@property (weak, nonatomic) IBOutlet NSButton * filtersActive;

@property (weak, nonatomic) IBOutlet NSPopUpButton * gotoPopup;
@property (weak, nonatomic) IBOutlet NSTextField * gotoField;

@property (strong, nonatomic) IBOutlet NSArrayController * gpCatalogController;

@property (strong, nonatomic) NSPredicate * subBasePredicate;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;

// Name of the attribute in which the picture is being set into the target.
@property (strong, nonatomic) NSString * attributeString;

@property (nonatomic) BOOL selectingPicture;
@property (nonatomic, copy) void (^updateSearch)(NSModalResponse rc);
@end

@implementation GPCatalogPictureSelector

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch
               countrySearch:(NSPredicate *)countriesPredicate
               sectionSearch:(NSPredicate *)sectionsPredicate
                filterSearch:(NSPredicate *)filtersPredicate
         targetAttributeName:(NSString *)attributeName
            selectingPicture:(BOOL)selectingPicture {
    
    self = [super initWithWindowNibName:@"GPCatalogPictureSelector"];
    if (self) {
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _filtersPredicate = filtersPredicate;
        
        _attributeString = attributeName;
        _selectingPicture = selectingPicture;
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = _doc.managedObjectContext;
        
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        _gpCatalogSortDescriptors = @[catalogNumberSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:NO];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:NO];
        _filterSearchController = [[GPFilterSearch alloc] initWithPredicate:filtersPredicate];
        _subvarietySearchController = [[GPSubvarietySearch alloc] initWithPredicate:nil forStamp:NO];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Place the AssistedSearch views into panels which will be launched as sheets.
    self.countrySearchController.panel = [[NSPanel alloc] initWithContentRect:self.countrySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countrySearchController.panel setContentView:self.countrySearchController.view];
    
    self.sectionSearchController.panel = [[NSPanel alloc] initWithContentRect:self.sectionSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionSearchController.panel setContentView:self.sectionSearchController.view];
    
    self.filterSearchController.panel = [[NSPanel alloc] initWithContentRect:self.filterSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.filterSearchController.panel setContentView:self.filterSearchController.view];
    
    self.subvarietySearchController.panel = [[NSPanel alloc] initWithContentRect:self.subvarietySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.subvarietySearchController.panel setContentView:self.subvarietySearchController.view];
    
    // Show the active filter search.
    [self.filtersActive setTitle:self.filterSearchController.filtersSelected];
    
    if (self.selectingPicture) {
        [self.gpCatalogBox setTitle:CHOOSE_PICTURE_FROM_CATALOG];
    }
    else {
        [self.gpCatalogBox setTitle:CHOOSE_GPID_FROM_CATALOG];
    }
    
    [self queryGPCatalog];
    
    GPCatalogPictureSelector * __weak weakSelf = self;
    self.updateSearch = ^(NSModalResponse rc){
        if (weakSelf.currMajorVariety)
            [weakSelf updateSubvarietiesSearch];
        else
            [weakSelf updateCurrentSearch];
    };
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Select a picture from the GP Catalog";
}

- (void)queryGPCatalog {
    [self.gpCatalogController setFetchPredicate:self.assistedSearch.predicate];
    [self.gpCatalogController fetch:self];
}

- (void)querySubvarieties {
    [self.gpCatalogController setFetchPredicate:self.subvarietiesSearch];
    [self.gpCatalogController fetch:self];
}

// Update the current search based on the three saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
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
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.assistedSearch.predicate = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
    }
    
    // Refresh the active filter search.
    [self.filtersActive setTitle:self.filterSearchController.filtersSelected];
    
    // Refetch the GP Catalog Data.
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
    
    [self querySubvarieties];
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
    [self.window beginSheet:self.countrySearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    [self.window beginSheet:self.countrySearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    [self.window beginSheet:self.filterSearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openSubvarietySearchPanel:(id)sender {
    [self.window beginSheet:self.subvarietySearchController.panel completionHandler:self.updateSearch];
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
    [self queryGPCatalog];
    
    [self.gpCatalogController setSelectedObjects:@[self.currMajorVariety]];
    NSUInteger indexOfMajorVariety = self.gpCatalogController.selectionIndex;
    
    // Make sure the selection is visable.
    [self.gpCatalogTable scrollRowToVisible:indexOfMajorVariety];
    self.currMajorVariety = nil;
}

- (IBAction)copyPictureToTarget:(id)sender {
    NSArray * selectedEntries = self.gpCatalogController.selectedObjects;
    if (!selectedEntries) return;
    GPCatalog * selectedEntry = selectedEntries[0];
    
    if (self.selectingPicture) {
        // Create the copy-from URL.
        NSURL * copyFromURL = [[[self document] fileURL] URLByAppendingPathComponent:selectedEntry.default_picture];
        
        // Hash a new filename for the picture's target destination.
        NSString * targetPicFN;
        
        if (self.targetGPCatalog) {
            // Hash a new filename for the picture's target destination.
            targetPicFN = [self.doc hashFileNameForGPID:self.targetGPCatalog.gp_catalog_number andAttributeName:self.attributeString];

            self.targetGPCatalog.default_picture = targetPicFN;
        }
        else if (self.targetLooksLike) {
            // Hash a new filename for the picture's target destination.
            targetPicFN = [self.doc hashFileNameForGPID:self.targetLooksLike.gp_lookslike_number andAttributeName:self.attributeString];
            
            self.targetLooksLike.picture = targetPicFN;
        }
        
        if (!targetPicFN) return;
        
        // Create the copy-to URL.
        NSURL * copyToURL = [[[self document] fileURL] URLByAppendingPathComponent:targetPicFN];
        
        // Delete the existing picture if there is one.
        NSFileManager * fileManager = [NSFileManager defaultManager];
        [fileManager removeItemAtURL:copyToURL error:nil];
        
        // Copy the file.
        NSError * error;
        if (![fileManager copyItemAtURL:copyFromURL toURL:copyToURL error:&error]) {
            NSLog(@"Error copying image file: %@, %@", error, error.userInfo);
            return;
        }
    }
    else {
        if (self.targetLooksLike) {
            [self.targetLooksLike addTheseGPCatalogEntries:[NSSet setWithArray:selectedEntries]];
        }
    }
    
    [self.window performClose:sender];
}

@end
