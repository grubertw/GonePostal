//
//  GPCatalogPictureSelector.m
//  GonePostal
//
//  Created by Travis Gruber on 6/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogPictureSelector.h"
#import "GPDocument.h"

@interface GPCatalogPictureSelector ()
@property (strong, nonatomic) GPDocument * doc;

@property (weak, nonatomic) IBOutlet NSTableView * gpCatalogTable;
@property (weak, nonatomic) IBOutlet NSButton * filtersActive;

@property (strong, nonatomic) IBOutlet NSArrayController * gpCatalogController;

@property (strong, nonatomic) NSPredicate * subBasePredicate;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;

// Name of the attribute in which the picture is being set into the target.
@property (strong, nonatomic) NSString * attributeString;
@end

@implementation GPCatalogPictureSelector

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate targetAttributeName:(NSString *)attributeName {
    
    self = [super initWithWindowNibName:@"GPCatalogPictureSelector"];
    if (self) {
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _filtersPredicate = filtersPredicate;
        
        _attributeString = attributeName;
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = _doc.managedObjectContext;
        
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *subTypeSort = [[NSSortDescriptor alloc] initWithKey:@"subvarietyType.sortID" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        _gpCatalogSortDescriptors = @[gpCountrySort, groupSort, subTypeSort, catalogNumberSort];
        
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
    
    [self queryGPCatalog];
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
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
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

- (IBAction)openCountriesSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.countrySearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.sectionSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.filterSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSubvarietySearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.subvarietySearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (self.currMajorVariety)
        [self updateSubvarietiesSearch];
    else
        [self updateCurrentSearch];
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
    
    NSFileManager * fileManager = [NSFileManager defaultManager];
    
    // Copy the file.
    NSError * error;
    BOOL writeRC = [fileManager copyItemAtURL:copyFromURL toURL:copyToURL error:&error];
    if (!writeRC) {
        NSLog(@"Error copying image file: %@, %@", error, error.userInfo);
        return;
    }
    
    [self.window performClose:sender];
}

@end
