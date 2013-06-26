//
//  GPCatalogEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogEditor.h"
#import "GPDocument.h"
#import "GPAddToCatalogController.h"
#import "GPAddSubvariety.h"
#import "GPCatalog+Duplicate.h"
#import "GPCatalogSet.h"
#import "GPSetController.h"
#import "PlateUsage.h"
#import "PlateNumber.h"
#import "GPPlateUsageController.h"
#import "Cachet.h"
#import "LooksLike.h"
#import "GPLooksLikeController.h"
#import "BureauPrecancel.h"
#import "Cancelations.h"
#import "GPTopicsController.h"
#import "GPPicture.h"
#import "StoredSearch.h"
#import "Country.h"
#import "AlternateCatalog.h"
#import "AlternateCatalogName.h"
#import "GPCatalogGroup.h"
#import "GPCatalogDefaults.h"
#import "GPStampExamples.h"
#import "GPSubvarietySearch.h"
#import "GPAddBureauPrecancel.h"
#import "GPCustomSearch.h"

// Private members.
@interface GPCatalogEditor ()
@property (strong, nonatomic) IBOutlet NSTableView * gpCatalogTable;

@property (weak, nonatomic) IBOutlet NSScrollView * gpPicturesScroller;
@property (weak, nonatomic) IBOutlet NSView * gpPicturesScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * identScroller;
@property (weak, nonatomic) IBOutlet NSView * identScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * infoScroller;
@property (weak, nonatomic) IBOutlet NSView * infoScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * platesScroller;
@property (weak, nonatomic) IBOutlet NSView * platesScrollContent;
@property (weak, nonatomic) IBOutlet NSCollectionView * plateUsageCollectionView;
@property (weak, nonatomic) IBOutlet NSCollectionView * cachetCollectionView;

@property (weak, nonatomic) IBOutlet NSPopUpButton * gotoPopup;
@property (weak, nonatomic) IBOutlet NSTextField * gotoField;

@property (weak, nonatomic) IBOutlet NSButton * filtersActive;

@property (strong, nonatomic) NSPanel * addToSetPanel;
@property (weak, nonatomic) IBOutlet NSView * addToSetSelector;
@property (weak, nonatomic) IBOutlet NSComboBox * setSelectorCombo;

@property (strong, nonatomic) NSPanel * addToLooksLikePanel;
@property (weak, nonatomic) IBOutlet NSView * addToLooksLikeSelector;

@property (weak, nonatomic) IBOutlet NSPopover * setsPopover;
@property (weak, nonatomic) IBOutlet GPSetPopoverController * setsPopoverController;

@property (weak, nonatomic) IBOutlet NSPopover * looksLikePopover;
@property (weak, nonatomic) IBOutlet GPLooksLikePopoverController * looksLikePopoverController;

@property (weak, nonatomic) IBOutlet NSTableView * plateNumberCombinationsTable;
@property (weak, nonatomic) IBOutlet NSTableColumn * plateNumberComboUnknownColumn;

@property (weak, nonatomic) IBOutlet NSTableView * bureauPrecancelsTable;

@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogEntriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * countriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * formatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogNamesController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogSectionsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpGroupsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogSetsController;
@property (weak, nonatomic) IBOutlet NSArrayController * plateUsageController;
@property (weak, nonatomic) IBOutlet NSArrayController * plateNumberCombinationsController;
@property (weak, nonatomic) IBOutlet NSArrayController * cachetController;
@property (weak, nonatomic) IBOutlet NSArrayController * looksLikeController;
@property (weak, nonatomic) IBOutlet NSArrayController * precancelsController;
@property (weak, nonatomic) IBOutlet NSArrayController * cancelationsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsInGPCatalogController;
@property (weak, nonatomic) IBOutlet NSArrayController * identificationPicturesController;
@property (weak, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (strong, nonatomic) NSArray * gpCatalogEntries;

@property (strong, nonatomic) NSPredicate * subBasePredicate;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;

@property (strong, nonatomic) Topic * selectedTopic;
@end

@implementation GPCatalogEditor

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
    self.currSearch = self.assistedSearch.predicate;
    [self queryGPCatalog];
}

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate {
    
    self = [super initWithWindowNibName:@"GPCatalogEditor"];
    if (self) {
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _filtersPredicate = filtersPredicate;
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        // Create the sort descripors
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *subTypeSort = [[NSSortDescriptor alloc] initWithKey:@"subvarietyType.sortID" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[gpCountrySort, groupSort, subTypeSort, catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        self.altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        self.altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *gpSetSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.gpCatalogSetsSortDescriptors = @[gpSetSort];
        
        NSSortDescriptor *plateUsageSort = [[NSSortDescriptor alloc] initWithKey:@"plate_number" ascending:YES];
        self.plateUsageSortDescriptors = @[plateUsageSort];
        
//        NSComparator plateNumberCompare = ^(id obj1, id obj2) {
//            if ([obj1 integerValue] > [obj2 integerValue]) {
//                return (NSComparisonResult)NSOrderedDescending;
//            }
//            
//            if ([obj1 integerValue] < [obj2 integerValue]) {
//                return (NSComparisonResult)NSOrderedAscending;
//            }
//            return (NSComparisonResult)NSOrderedSame;
//        };
        
        NSSortDescriptor *plateNumber1Sort = [[NSSortDescriptor alloc] initWithKey:@"plate1" ascending:YES];
        NSSortDescriptor *plateNumber2Sort = [[NSSortDescriptor alloc] initWithKey:@"plate2" ascending:YES];
        NSSortDescriptor *numberOfStampsSort = [[NSSortDescriptor alloc] initWithKey:@"number_of_stamps" ascending:YES];
        self.plateNumberSortDescriptors = @[plateNumber1Sort, plateNumber2Sort, numberOfStampsSort];
        
        NSSortDescriptor *cachetSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cachet_number" ascending:YES];
        self.cachetSortDescriptors = @[cachetSort];
        
        NSSortDescriptor *precancelSort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        self.precancelsSortDescriptors = @[precancelSort];
        
        NSSortDescriptor *cancelationSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cancelation_number" ascending:YES];
        self.cancelationsSortDescriptors = @[cancelationSort];
        
        NSSortDescriptor *looksLikeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.looksLikeSortDescriptors = @[looksLikeSort];
        
        NSSortDescriptor *topicsSort = [[NSSortDescriptor alloc] initWithKey:@"topic_name" ascending:YES];
        self.topicsSortDescriptors = @[topicsSort];
        
        NSSortDescriptor *identPicsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.identificationPicturesSortDescriptors = @[identPicsSort];
        
        NSSortDescriptor *subTypesSort = [[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES];
        self.subvarietyTypesSortDescriptors = @[subTypesSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
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
    
    [self.gpPicturesScroller setDocumentView:self.gpPicturesScrollContent];
    [self.identScroller setDocumentView:self.identScrollContent];
    [self.infoScroller setDocumentView:self.infoScrollContent];
    [self.platesScroller setDocumentView:self.platesScrollContent];
    
    // Set the scrollers to the top.
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.identScroller documentView] frame]) -
                                    [[self.identScroller contentView] bounds].size.height);
    [[self.identScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.infoScroller documentView] frame]) -
                                    [[self.infoScroller contentView] bounds].size.height);
    [[self.infoScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.platesScroller documentView] frame]) -
                                    [[self.platesScroller contentView] bounds].size.height);
    [[self.platesScroller documentView] scrollPoint:newOrigin];
    
    // Create a panel used to help the user select a set.
    self.addToSetPanel = [[NSPanel alloc] initWithContentRect:self.addToSetSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToSetPanel setContentView:self.addToSetSelector];
    
    // Create a panel to help user select a looks like.
    self.addToLooksLikePanel = [[NSPanel alloc] initWithContentRect:self.addToLooksLikeSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToLooksLikePanel setContentView:self.addToLooksLikeSelector];
    
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
    
    // Fetch the GP Catalog Data.
    self.currSearch = self.assistedSearch.predicate;
    [self queryGPCatalog];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"GP Catalog Editor";
}

- (void)queryGPCatalog {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    [fetchRequest setPredicate:self.currSearch];

    NSError *error = nil;
    self.gpCatalogEntries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.gpCatalogEntries == nil) {
        NSLog(@"Error fetching GPCatalog entries: %@ %@", error, error.userInfo);
    }
}

- (void)querySubvarieties {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setPredicate:self.subvarietiesSearch];
    
    NSError *error = nil;
    self.gpCatalogEntries = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (self.gpCatalogEntries == nil) {
        NSLog(@"Error fetching GPCatalog entries: %@ %@", error, error.userInfo);
    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField * textField = aNotification.object;
    
    if ([textField isEqualTo:self.gotoField]) {
        NSArray * entries = self.gpCatalogEntriesController.arrangedObjects;
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

- (IBAction)openAddToGPCatalog:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPAddToCatalogController * controller = [[GPAddToCatalogController alloc] initWithWindowNibName:@"GPAddToCatalogController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setCatalogEditor:self];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddSubvariety:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    GPCatalog * entry = nil;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * possibleEntry = [entries objectAtIndex:0];
        // Only allow creation of subvarieties on top-level major varieties.
        if (possibleEntry.majorVariety == nil) {
            entry = possibleEntry;
        }
        else {
            // If this is clicked from the subvarieties screen, add another
            // subvariety to the major variety of the selected entry.
            entry = possibleEntry.majorVariety;
        }
    }
    
    if (entry == nil) return;
    
    GPAddSubvariety * controller = [[GPAddSubvariety alloc] initWithWindowNibName:@"GPAddSubvariety"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setTheMajorVariety:entry];
    [controller setCatalogEditor:self];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)duplicateGPCatalogEntry:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<entries.count; i++) {
        GPCatalog * entry = [entries objectAtIndex:i];
        [entry duplicateFromThis];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
    }
    
    if (self.currMajorVariety)
        [self querySubvarieties];
    else
        [self queryGPCatalog];
}

- (IBAction)removeSelectedGPCatalogEntries:(id)sender {
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<selectedEntries.count; i++) {
        GPCatalog * entry = [selectedEntries objectAtIndex:i];
        [self.managedObjectContext deleteObject:entry];
        
        NSError * error;
        if (![self.managedObjectContext save:&error]) {
            NSAlert * errSheet;
            if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
                && [error code] == NSValidationRelationshipDeniedDeleteError) {
                errSheet = [NSAlert alertWithMessageText:@"Delete Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Unable to remove catalog entry. Entry has one or more subvarieties."];
            }
            else {
                errSheet = [NSAlert alertWithError:error];
            }
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [self.managedObjectContext undo];
            return;
        }
    }
    
    if (self.currMajorVariety)
        [self querySubvarieties];
    else
        [self queryGPCatalog];
}

- (IBAction)addToGPCatalogSet:(id)sender {
    // Determine the current country and section being viewed.
    // If there are multiple or none, set the catalogSetsController's
    // fetch predicate to nil to fetch all sets.
    Country * selectedCountry;
    GPCatalogGroup * selectedSection;
    
    if (   [self.countrySearchController.itemsInSearch count] == 1
        && [self.sectionSearchController.itemsInSearch count] == 1) {
        selectedCountry = self.countrySearchController.itemsInSearch[0];
        selectedSection = self.sectionSearchController.itemsInSearch[0];
        
        NSPredicate * setFilter = [NSPredicate predicateWithFormat:@"country.country_sort_id == %@ and catalogGroup.group_number == %@", selectedCountry.country_sort_id, selectedSection.group_number];
        [self.gpCatalogSetsController setFetchPredicate:setFilter];
        [self.gpCatalogSetsController fetch:sender];
    }
    else {
        [self.gpCatalogSetsController setFetchPredicate:nil];
        [self.gpCatalogSetsController fetch:sender];
    }
    
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToSetPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToSet:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
 
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        NSArray * setList = [self.gpCatalogSetsController arrangedObjects];
        if (setList == nil) return;
        
        NSInteger selectedSetIndex = self.setSelectorCombo.indexOfSelectedItem;
        if (selectedSetIndex == -1) return;
        
        GPCatalogSet * catalogSet = [setList objectAtIndex:selectedSetIndex];
        [catalogSet addGpCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];        
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToSetPanel];
    [self.addToSetPanel close];
}

- (IBAction)addToLooksLike:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToLooksLikePanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToLooksLike:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
    
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        LooksLike * ll;
        NSArray * selectedLooksLike = self.looksLikeController.selectedObjects;
        if (selectedLooksLike == nil) return;
        
        ll = [selectedLooksLike objectAtIndex:0];
        if (ll == nil) return;
        
        [ll addTheseGPCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToLooksLikePanel];
    [self.addToLooksLikePanel close];
}

- (IBAction)manageDefaults:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPCatalogDefaults * controller = [[GPCatalogDefaults alloc] initWithWindowNibName:@"GPCatalogDefaults"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageSets:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPSetController * controller = [[GPSetController alloc] initWithWindowNibName:@"GPSetController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageLooksLike:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    [doc loadAssistedSearch:ASSISTED_LOOKS_LIKE_EDITOR_SEARCH_ID];
    GPLooksLikeController * controller = [[GPLooksLikeController alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate];
    
    [doc addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageTopics:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPTopicsController * controller = [[GPTopicsController alloc] initWithWindowNibName:@"GPTopicsController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
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

- (IBAction)viewSubvarieties:(id)sender {
    NSInteger row = [self.gpCatalogTable rowForView:sender];
    GPCatalog * theMajorVariety = self.gpCatalogEntriesController.arrangedObjects[row];
    
    if (theMajorVariety != nil && (theMajorVariety.subvarieties.count > 0)) {
        self.subBasePredicate = [NSPredicate predicateWithFormat:@"majorVariety.gp_catalog_number like %@", theMajorVariety.gp_catalog_number];
        
        [self updateSubvarietiesSearch];
        
        // Set the selection to the first subvariety.
        [self.gpCatalogEntriesController setSelectionIndex:0];
        
        self.currMajorVariety = theMajorVariety;
    }
}

- (IBAction)closeSubvarieties:(id)sender {
    // Restore the current search.
    [self queryGPCatalog];
    
    [self.gpCatalogEntriesController setSelectedObjects:@[self.currMajorVariety]];
    NSUInteger indexOfMajorVariety = self.gpCatalogEntriesController.selectionIndex;
    
    // Make sure the selection is visable.
    [self.gpCatalogTable scrollRowToVisible:indexOfMajorVariety];
    self.currMajorVariety = nil;
}

- (IBAction)editCustomSearch:(id)sender {
    GPCustomSearch * customSearchController = [[GPCustomSearch alloc] initWithStoredSearchIdentifier:@(CUSTOM_GP_CATALOG_SEARCH_ID)];
    [self.document addWindowController:customSearchController];
    [customSearchController.window makeKeyAndOrderFront:sender];
}

- (IBAction)executeCustomSearch:(id)sender {
    if (!self.currCustomSearch || !self.currCustomSearch.predicate) return;
    
    self.currSearch = self.currCustomSearch.predicate;
    [self queryGPCatalog];
}

- (IBAction)viewSetsForGPCatalogEntry:(id)sender {
    NSInteger row = [self.gpCatalogTable rowForView:sender];
    NSButton * llButton = (NSButton *)sender;
    
    GPCatalog * selectedEntry = self.gpCatalogEntriesController.arrangedObjects[row];
    [self.setsPopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.setsPopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)viewLooksLikeForGPCatalogEntry:(id)sender {
    NSInteger row = [self.gpCatalogTable rowForView:sender];
    NSButton * llButton = (NSButton *)sender;
    
    GPCatalog * selectedEntry = self.gpCatalogEntriesController.arrangedObjects[row];
    [self.looksLikePopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.looksLikePopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)addAlternateCatalog:(id)sender {
    [self.altCatalogsController add:self];
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addDefaultPicture:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"default_picture"];
        if (fileName == nil) return;
        
        entry.default_picture = fileName;
    }
}

- (IBAction)addAlternatePicture1:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_1"];
        if (fileName == nil) return;
        
        entry.alternate_picture_1 = fileName;
      }
}

- (IBAction)addAlternatePicture2:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_2"];
        if (fileName == nil) return;
        
        entry.alternate_picture_2 = fileName;
    }
}

- (IBAction)addAlternatePicture3:(id)sender {
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_3"];
        if (fileName == nil) return;
        
        entry.alternate_picture_3 = fileName;
    }
}

- (IBAction)addAlternatePicture4:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_4"];
        if (fileName == nil) return;
        
        entry.alternate_picture_4 = fileName;
    }
}

- (IBAction)addAlternatePicture5:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_5"];
        if (fileName == nil) return;
        
        entry.alternate_picture_5 = fileName;
    }
}

- (IBAction)addAlternatePicture6:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_6"];
        if (fileName == nil) return;
        
        entry.alternate_picture_6 = fileName;
    }
}

- (IBAction)addIdentificationPicture:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    NSString * numIdentPics = [NSString stringWithFormat:@"extraPicture %ld", [entry.extraPictures count]];
    
    NSString * fileName = [self.document addPictureToWrapperUsingGPID:entry.gp_catalog_number forAttribute:numIdentPics];
    if (fileName == nil) return;
    
    GPPicture * identPic = [NSEntityDescription insertNewObjectForEntityForName:@"GPPicture" inManagedObjectContext:self.managedObjectContext];
    identPic.filename = fileName;
    
    [entry addExtraPicturesObject:identPic];
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeIdentificationPicture:(id)sender {
    NSArray * selectedIdentPics = self.identificationPicturesController.selectedObjects;
    if (selectedIdentPics == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeExtraPictures:[NSSet setWithArray:selectedIdentPics]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)openStampExamples:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPStampExamples * examplesController = [[GPStampExamples alloc] initWithGPCatalog:entry];
    [self.document addWindowController:examplesController];
    [examplesController.window makeKeyAndOrderFront:sender];
}

- (IBAction)addPlateUsage:(id)sender {
    PlateUsage * pu = [NSEntityDescription insertNewObjectForEntityForName:@"PlateUsage" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    // Increment the plate_number based on number of plate usages present.
    NSUInteger nextPlateNumber = entry.plateUsage.count + 1;
    [pu setPlate_number:[NSNumber numberWithUnsignedInteger:nextPlateNumber]];
    [pu setUsage_color:entry.color];
    
    [entry addPlateUsageObject:pu];
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
    
    [self tableViewSelectionDidChange:nil];
}

- (IBAction)removePlateUsage:(id)sender {
    NSArray * selectedPlateUsages = self.plateUsageController.selectedObjects;
    if (selectedPlateUsages == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateUsage:[NSSet setWithArray:selectedPlateUsages]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
    
    [self tableViewSelectionDidChange:nil];
}

- (IBAction)addPlateNumberCombination:(id)sender {
    PlateNumber * pn = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
   
    [self.plateNumberCombinationsController insertObject:pn atArrangedObjectIndex:[self.plateNumberCombinationsController.arrangedObjects count]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removePlateNumberCombination:(id)sender {
    NSArray * selectedPlateNumbers = self.plateNumberCombinationsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateNumbers:[NSSet setWithArray:selectedPlateNumbers]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addCachet:(id)sender {
    Cachet * cachet = [NSEntityDescription insertNewObjectForEntityForName:@"Cachet" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addCachetsObject:cachet];
    
    cachet.gp_cachet_number = entry.gp_catalog_number;
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeCachet:(id)sender {
    NSArray * selectedCachets = self.cachetController.selectedObjects;
    if (selectedCachets == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeCachets:[NSSet setWithArray:selectedCachets]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addPrecancel:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPAddBureauPrecancel * controller = [[GPAddBureauPrecancel alloc] initWithGPCatalog:entry];
    [self.document addWindowController:controller];
    
    [controller.window makeKeyAndOrderFront:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addPictureToPrecancel:(NSButton *)sender {
    NSInteger row = [self.bureauPrecancelsTable rowForView:sender];
    BureauPrecancel * bc = self.precancelsController.arrangedObjects[row];
    
    NSString * fileName = [self.document addPictureToWrapperUsingGPID:bc.gp_precancel_number forAttribute:@"picture"];
    if (fileName == nil) return;
    
    [bc setPicture:fileName];
}

- (IBAction)addCancelation:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    Cancelations * cancelation = [NSEntityDescription insertNewObjectForEntityForName:@"Cancelations" inManagedObjectContext:self.managedObjectContext];
    
    [self.cancelationsController insertObject:cancelation atArrangedObjectIndex:[self.cancelationsController.arrangedObjects count]];
    
    cancelation.gp_cancelation_number = entry.gp_catalog_number;
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeCancelation:(id)sender {
    NSArray * selectedCancelations = self.cancelationsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeCancelations:[NSSet setWithArray:selectedCancelations]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addPictureToCancelation:(id)sender {
    NSArray * selectedCancels = self.cancelationsController.selectedObjects;
    if (selectedCancels) {
        Cancelations * cancel = selectedCancels[0];
        
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:cancel.gp_cancelation_number forAttribute:@"picture"];
        if (fileName == nil) return;
        
        [cancel setPicture:fileName];
    }
}

- (IBAction)addTopic:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addTopicsObject:self.selectedTopic];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeTopic:(id)sender {
    NSArray * topics = self.topicsController.selectedObjects;
    if (topics == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeTopics:[NSSet setWithArray:topics]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = entries[0];
    
    NSUInteger numPlates = [entry.plateUsage count];
    
    // Iterate through the table columns in the plate combos table.
    // Hide columnes for plate usages that do not exist.
    NSArray * columns = [self.plateNumberCombinationsTable tableColumns];
    for (NSUInteger i=0; i < 8; i++) {
        NSTableColumn * column = columns[i];
        if (i < numPlates) {
            [column setHidden:NO];
        }
        else {
            [column setHidden:YES];
        }
    }
    
    if (numPlates > 1) {
        [self.plateNumberComboUnknownColumn setHidden:NO];
    }
    else {
        [self.plateNumberComboUnknownColumn setHidden:YES];
    }
}

@end
