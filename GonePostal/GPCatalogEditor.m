//
//  GPCatalogEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogEditor.h"
#import "GPAddToCatalogController.h"
#import "GPAddSubvariety.h"
#import "GPCatalog+Duplicate.h"
#import "GPCatalogSet+CoreDataClass.h"
#import "PlateUsage.h"
#import "PlateNumber.h"
#import "GPPlateUsageController.h"
#import "Cachet+CoreDataClass.h"
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
#import "GPCatalogPictureSelector.h"
#import "GPPDFViewController.h"
#import "NumberOfStampsInPlate.h"
#import "GPPlateCombinationsEditor.h"
#import "Valuation.h"
#import "PriceList.h"
#import "Format.h"
#import "StampFormat.h"
#import "GPCatalogAlbumSize.h"
#import "GonePostal-Swift.h"

// Private members.
@interface GPCatalogEditor ()
@property (strong, nonatomic) IBOutlet NSTableView * gpCatalogTable;
@property (strong, nonatomic) IBOutlet NSTabView * gpCatalogDetailTabs;

@property (weak, nonatomic) IBOutlet NSScrollView * gpPicturesScroller;
@property (weak, nonatomic) IBOutlet NSView * gpPicturesScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * identScroller;
@property (weak, nonatomic) IBOutlet NSView * identScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * infoScroller;
@property (weak, nonatomic) IBOutlet NSView * infoScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * platesScroller;
@property (weak, nonatomic) IBOutlet NSView * platesScrollContent;
@property (weak, nonatomic) IBOutlet NSCollectionView * plateUsageCollectionView;

@property (weak, nonatomic) IBOutlet NSPopUpButton * gotoPopup;
@property (weak, nonatomic) IBOutlet NSTextField * gotoField;

@property (weak, nonatomic) IBOutlet NSButton * filtersActive;

@property (strong, nonatomic) NSPanel * addToLooksLikePanel;
@property (weak, nonatomic) IBOutlet NSView * addToLooksLikeSelector;

@property (weak, nonatomic) IBOutlet NSPopover * setsPopover;
@property (weak, nonatomic) IBOutlet GPSetPopoverController * setsPopoverController;

@property (weak, nonatomic) IBOutlet NSPopover * looksLikePopover;
@property (weak, nonatomic) IBOutlet GPLooksLikePopoverController * looksLikePopoverController;

@property (weak, nonatomic) IBOutlet NSTableView * bureauPrecancelsTable;
@property (weak, nonatomic) IBOutlet NSTableView * valuationCatagoriesTable;

@property (weak, nonatomic) IBOutlet NSArrayController * countriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * formatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogNamesController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogSectionsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpGroupsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogSetsController;
@property (weak, nonatomic) IBOutlet NSArrayController * numberOfStampsInPlateController;
@property (weak, nonatomic) IBOutlet NSArrayController * plateUsageController;
@property (weak, nonatomic) IBOutlet NSArrayController * cachetController;
@property (weak, nonatomic) IBOutlet NSArrayController * looksLikeController;
@property (weak, nonatomic) IBOutlet NSArrayController * precancelsController;
@property (weak, nonatomic) IBOutlet NSArrayController * cancelationsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsInGPCatalogController;
@property (weak, nonatomic) IBOutlet NSArrayController * identificationPicturesController;
@property (weak, nonatomic) IBOutlet NSArrayController * customSearchController;
@property (weak, nonatomic) IBOutlet NSArrayController * attachmentController;
@property (weak, nonatomic) IBOutlet NSArrayController * priceListController;
@property (weak, nonatomic) IBOutlet NSArrayController * valuationPerFormatController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogDateController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogPeopleController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpPlateSizeController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogQuantityController;
@property (weak, nonatomic) IBOutlet NSArrayController * allowedStampFormatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogAlbumSizeController;

@property (strong, nonatomic) NSMutableArray * gpCatalogEntries;

@property (strong, nonatomic) NSPredicate * subBasePredicate;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;

@property (strong, nonatomic) Topic * selectedTopic;

@property (nonatomic, copy) void (^updateSearch)(NSModalResponse rc);
@end

@implementation GPCatalogEditor

// Update the current search based on the three saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
    [predicateArray addObject:[NSPredicate predicateWithFormat:GPDocument.BASE_GP_CATALOG_QUERY]];
    
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
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[catalogNumberSort];
        
        NSSortDescriptor *subvarietySort = [[NSSortDescriptor alloc] initWithKey:@"subvarietyType.sortID" ascending:YES];
        self.subvarietySortDescriptors = @[subvarietySort, catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *stampFormatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _stampFormatsSortDescriptors = @[stampFormatSort];
        
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
        
        NSSortDescriptor *numberOfStampsInPlateSort = [[NSSortDescriptor alloc] initWithKey:@"numberOfStamps" ascending:YES];
        _numberOfStampsInPlateSortDescriptors = @[numberOfStampsInPlateSort];
        
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
        
        NSSortDescriptor *plateNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_plate_combination_number" ascending:YES];
        self.plateNumberSortDescriptors = @[plateNumberSort];
        
        NSSortDescriptor *cachetSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cachet_number" ascending:YES];
        self.cachetSortDescriptors = @[cachetSort];
        
        NSSortDescriptor *precancelSort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        self.precancelsSortDescriptors = @[precancelSort];
        
        NSSortDescriptor *cancelationSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cancelation_number" ascending:YES];
        self.cancelationsSortDescriptors = @[cancelationSort];
        
        NSSortDescriptor *looksLikeSort = [[NSSortDescriptor alloc] initWithKey:@"gp_lookslike_number" ascending:YES];
        self.looksLikeSortDescriptors = @[looksLikeSort];
        
        NSSortDescriptor *topicsSort = [[NSSortDescriptor alloc] initWithKey:@"topic_name" ascending:YES];
        self.topicsSortDescriptors = @[topicsSort];
        
        NSSortDescriptor *identPicsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.identificationPicturesSortDescriptors = @[identPicsSort];
        
        NSSortDescriptor *subTypesSort = [[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES];
        self.subvarietyTypesSortDescriptors = @[subTypesSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
        NSSortDescriptor *attachmentSort = [[NSSortDescriptor alloc] initWithKey:@"gp_attachment_number" ascending:YES];
        _attachmentsSortDescriptors = @[attachmentSort];
        
        NSSortDescriptor *subjectSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _subjectsSortDescriptors = @[subjectSort];
        
        NSSortDescriptor *priceListSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _priceListSortDescriptors = @[priceListSort];
        
        NSSortDescriptor *valuationPerFormatSort = [[NSSortDescriptor alloc] initWithKey:@"stampFormat.name" ascending:YES];
        _valuationPerFormatSortDescriptors = @[valuationPerFormatSort];
        
        NSSortDescriptor *salesGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _salesGroupSortDescriptors = @[salesGroupSort];
        
        NSSortDescriptor *gpCatalogDateSort = [[NSSortDescriptor alloc] initWithKey:@"dateType.name" ascending:YES];
        _gpCatalogDateSortDescriptors = @[gpCatalogDateSort];
        
        NSSortDescriptor *gpCatalogPeopleSort = [[NSSortDescriptor alloc] initWithKey:@"peopleType.name" ascending:YES];
        _gpCatalogPeopleSortDescriptors = @[gpCatalogPeopleSort];
        
        NSSortDescriptor *gpCatalogPlateSizeSort = [[NSSortDescriptor alloc] initWithKey:@"plateSizeType.name" ascending:YES];
        _gpCatalogPlateSizeSortDescriptors = @[gpCatalogPlateSizeSort];
        
        NSSortDescriptor *gpCatalogQuantitySort = [[NSSortDescriptor alloc] initWithKey:@"quantityType.name" ascending:YES];
        _gpCatalogQuantitySortDescriptors = @[gpCatalogQuantitySort];
        
        NSSortDescriptor *gpCatalogAlbumSizeSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _gpCatalogAlbumSizeSortDescriptors = @[gpCatalogAlbumSizeSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:NO];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:NO];
        _filterSearchController = [[GPFilterSearch alloc] initWithPredicate:filtersPredicate];
        _subvarietySearchController = [[GPSubvarietySearch alloc] initWithPredicate:nil forStamp:NO];
        
        _gpCatalogEntries = [NSMutableArray arrayWithCapacity:0];
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
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.gpPicturesScroller documentView] frame]) -
                            [[self.gpPicturesScroller contentView] bounds].size.height);
    [[self.gpPicturesScroller documentView] scrollPoint:newOrigin];
    
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
    
    GPCatalogEditor * __weak weakSelf = self;
    self.updateSearch = ^(NSModalResponse rc){
        if (weakSelf.currMajorVariety)
            [weakSelf updateSubvarietiesSearch];
        else
            [weakSelf updateCurrentSearch];
    };
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"GP Catalog Editor";
}

- (void)queryGPCatalog {
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCatalog"];
    [fetch setPredicate:self.currSearch];
    
    NSArray * results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    [self.gpCatalogEntries setArray:results];
    [self.gpCatalogEntriesController setSortDescriptors:self.gpCatalogEntriesSortDescriptors];
    [self.gpCatalogEntriesController rearrangeObjects];
}

- (void)querySubvarieties {
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCatalog"];
    [fetch setPredicate:self.subvarietiesSearch];
    
    NSArray * results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    [self.gpCatalogEntries setArray:results];
    if ([results count] > 1)
        [self.gpCatalogEntriesController setSortDescriptors:self.subvarietySortDescriptors];
    [self.gpCatalogEntriesController rearrangeObjects];
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
        GPCatalog * dup = [entry duplicateFromThis];
        [self.gpCatalogEntriesController insertObject:dup atArrangedObjectIndex:[self.gpCatalogEntriesController.arrangedObjects indexOfObject:entry]+1];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeSelectedGPCatalogEntries:(id)sender {
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<selectedEntries.count; i++) {
        GPCatalog * entry = [selectedEntries objectAtIndex:i];
        
        NSError * error;
        if (![entry validateForDelete:&error]) {
            NSAlert * alert = [[NSAlert alloc] init];
            alert.messageText = @"Delete Error";
            alert.informativeText = @"Unable to remove catalog entry. Entry has one or more subvarieties.";
            [alert beginSheetModalForWindow:self.window completionHandler:nil];
        }
        
        if (self.currMajorVariety) {
            [self.currMajorVariety removeSubvarietiesObject:entry];
        }
        
        [self.gpCatalogEntriesController removeObject:entry];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addToLooksLike:(id)sender {
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
    
    if (self.countrySearchController.predicate != nil) {
        [predicateArray addObject:self.countrySearchController.predicate];
    }
    
    if (self.sectionSearchController.predicate != nil) {
        [predicateArray addObject:self.sectionSearchController.predicate];
    }
    
    NSPredicate * llPredicate;
    
    if ([predicateArray count] == 1) {
        llPredicate = predicateArray[0];
    }
    else {
        llPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    [self.looksLikeController setFilterPredicate:llPredicate];
    [self.looksLikeController fetch:sender];
    
    [self.window beginSheet:self.addToLooksLikePanel completionHandler:nil];
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
    [self.window endSheet:self.addToLooksLikePanel];
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
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageLooksLike:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    [doc loadAssistedSearch:GPDocument.ASSISTED_LOOKS_LIKE_EDITOR_SEARCH_ID];
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
    [self.window beginSheet:self.countrySearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    [self.window beginSheet:self.sectionSearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    [self.window beginSheet:self.filterSearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openSubvarietySearchPanel:(id)sender {
    [self.window beginSheet:self.subvarietySearchController.panel completionHandler:self.updateSearch];
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

- (void)loadSubvarieties:(GPCatalog *)majorVariety {
    if (majorVariety != nil && (majorVariety.subvarieties.count > 0)) {
        self.subBasePredicate = [NSPredicate predicateWithFormat:@"majorVariety.gp_catalog_number like %@", majorVariety.gp_catalog_number];
        
        [self updateSubvarietiesSearch];
        
        // Set the selection to the first subvariety.
        [self.gpCatalogEntriesController setSelectionIndex:0];
        
        self.currMajorVariety = majorVariety;
    }
}

- (IBAction)viewSubvarieties:(id)sender {
    NSInteger row = [self.gpCatalogTable rowForView:sender];
    GPCatalog * theMajorVariety = self.gpCatalogEntriesController.arrangedObjects[row];
    
    [self loadSubvarieties:theMajorVariety];
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
    GPCustomSearch * customSearchController = [[GPCustomSearch alloc] initWithStoredSearchIdentifier:@(GPDocument.CUSTOM_GP_CATALOG_SEARCH_ID)];
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

- (IBAction)addAllowedStampFormat:(id)sender {
    if (self.allowedStampFormatToAdd == nil) return;
    
    [self.allowedStampFormatsController addObject:self.allowedStampFormatToAdd];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAllowedStampFormat:(id)sender {
    [self.allowedStampFormatsController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addAlternateCatalog:(id)sender {
    [self.altCatalogsController add:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAlternateCatalog:(id)sender {
    [self.altCatalogsController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogDate:(id)sender {
    [self.gpCatalogDateController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogDate:(id)sender {
    [self.gpCatalogDateController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPPlateSize:(id)sender {
    [self.gpPlateSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPPlateSize:(id)sender {
    [self.gpPlateSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)createAlbumSizesFromAvailableFormats:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        NSSet * availableFormats = [entry allowedStampFormats];
        
        for (StampFormat * format in availableFormats) {
            GPCatalogAlbumSize * albumSize = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogAlbumSize" inManagedObjectContext:self.managedObjectContext];
            albumSize.format = format;
            
            [entry addAlbumSizesObject:albumSize];
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addDefaultPicture:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.default_picture"];
        if (fileName == nil) return;
        
        entry.default_picture = fileName;
    }
}

- (IBAction)addDefaultPictureFromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
    
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.default_picture" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeDefaultPicture:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.default_picture = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.default_picture];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture1:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_1"];
        if (fileName == nil) return;
        
        entry.alternate_picture_1 = fileName;
      }
}

- (IBAction)addAlternatePicture1FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_1" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture1:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_1 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_1];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture2:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_2"];
        if (fileName == nil) return;
        
        entry.alternate_picture_2 = fileName;
    }
}

- (IBAction)addAlternatePicture2FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_2" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture2:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_2 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_2];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture3:(id)sender {
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_3"];
        if (fileName == nil) return;
        
        entry.alternate_picture_3 = fileName;
    }
}

- (IBAction)addAlternatePicture3FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_3" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture3:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_3 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_3];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture4:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_4"];
        if (fileName == nil) return;
        
        entry.alternate_picture_4 = fileName;
    }
}

- (IBAction)addAlternatePicture4FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_4" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture4:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_4 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_4];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture5:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_5"];
        if (fileName == nil) return;
        
        entry.alternate_picture_5 = fileName;
    }
}

- (IBAction)addAlternatePicture5FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_5" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture5:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_5 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_5];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addAlternatePicture6:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"GPCatalog.alternate_picture_6"];
        if (fileName == nil) return;
        
        entry.alternate_picture_6 = fileName;
    }
}

- (IBAction)addAlternatePicture6FromCatalog:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        
        [self.document loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
        GPDocument * doc = [self document];
        
        GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate targetAttributeName:@"GPCatalog.alternate_picture_6" selectingPicture:YES];
        [controller setTargetGPCatalog:entry];
        
        [doc addWindowController:controller];
        [controller.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)removeAlternatePicture6:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_6 = @"empty";
        
        // Delete the picture from the disk.
        NSURL * deleteFromURL = [[[self document] fileURL] URLByAppendingPathComponent:entry.alternate_picture_6];
        [[NSFileManager defaultManager] removeItemAtURL:deleteFromURL error:nil];
    }
}

- (IBAction)addIdentificationPicture:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    NSString * numIdentPics = [NSString stringWithFormat:@"extraPicture %ld", [entry.extraPictures count]];
    
    NSString * fileName = [self.document addImageToWrapperUsingGPID:entry.gp_catalog_number forAttribute:numIdentPics];
    if (fileName == nil) return;
    
    GPPicture * identPic = [NSEntityDescription insertNewObjectForEntityForName:@"GPPicture" inManagedObjectContext:self.managedObjectContext];
    identPic.filename = fileName;
    
    [entry addExtraPicturesObject:identPic];
}

- (IBAction)removeIdentificationPicture:(id)sender {
    NSArray * selectedIdentPics = self.identificationPicturesController.selectedObjects;
    if (selectedIdentPics == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeExtraPictures:[NSSet setWithArray:selectedIdentPics]];
}

- (IBAction)openStampExamples:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPStampExamples * examplesController = [[GPStampExamples alloc] initWithGPCatalog:entry];
    [self.document addWindowController:examplesController];
    [examplesController.window makeKeyAndOrderFront:sender];
}

- (IBAction)addNumberOfStampsInPlate:(id)sender {
    [self.numberOfStampsInPlateController insert:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeNumberOfStampsInPlate:(id)sender {
    [self.numberOfStampsInPlateController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addPlateUsage:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    PlateUsage * pu = [NSEntityDescription insertNewObjectForEntityForName:@"PlateUsage" inManagedObjectContext:self.managedObjectContext];
    
    // Increment the plate_number based on number of plate usages present.
    NSUInteger nextPlateNumber = entry.plateUsage.count + 1;
    [pu setPlate_number:[NSNumber numberWithUnsignedInteger:nextPlateNumber]];
    [pu setUsage_color:entry.color];
    
    [entry addPlateUsageObject:pu];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)copyPlateInformation:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [self.currMajorVariety copyPlateInfoIntoTarget:entry];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)copyCachetInformation:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [self.currMajorVariety copyCachetsIntoTarget:entry];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)openPlateCombinationsEditor:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil || [entries count] == 0) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPPlateCombinationsEditor * controller = [[GPPlateCombinationsEditor alloc] initWithGPCatalog:entry];
    [[self document] addWindowController:controller];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)openCachetsEditor:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil || [entries count] == 0) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPCachetEditor * controller = [[GPCachetEditor alloc] initWithGpCatalog:entry];
    [[self document] addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addPictureToPrecancel:(NSButton *)sender {
    NSInteger row = [self.bureauPrecancelsTable rowForView:sender];
    BureauPrecancel * bc = self.precancelsController.arrangedObjects[row];
    
    NSString * fileName = [self.document addImageToWrapperUsingGPID:bc.gp_precancel_number forAttribute:@"Precencel.picture"];
    if (fileName == nil) return;
    
    [bc setPicture:fileName];
}

- (IBAction)copyPrecancelInformation:(NSButton *)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [self.currMajorVariety copyBureauPrecancelInfoIntoTarget:entry];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addPictureToCancelation:(id)sender {
    NSArray * selectedCancels = self.cancelationsController.selectedObjects;
    if (selectedCancels) {
        Cancelations * cancel = selectedCancels[0];
        
        NSString * fileName = [self.document addImageToWrapperUsingGPID:cancel.gp_cancelation_number forAttribute:@"Cancelation.picture"];
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addAttachment:(id)sender {
    [self.attachmentController insert:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAttachment:(id)sender {
    [self.attachmentController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)viewAttachment:(id)sender {
    if (!self.attachmentController.selectedObjects) return;
    Attachment * atthmnt = self.attachmentController.selectedObjects[0];
    
    GPPDFViewController * controller = [[GPPDFViewController alloc] initWithAttachment:atthmnt];
    [[self document] addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)importPDF:(id)sender {
    if (!self.attachmentController.selectedObjects) return;
    Attachment * atthmnt = self.attachmentController.selectedObjects[0];
    
    GPDocument * doc = [self document];
    atthmnt.filename = [doc addPDFToWrapperUsingGPID:atthmnt.gp_attachment_number forAttribute:@"GPCatalog.attachment"];
}

// Adds/Removes level 1 valuation nodes from a GPCatalog entry,
// based on it's format type.
- (IBAction)reconstrainFormatValuationNodes:(id)sender {
    NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
    if (!selectedGPCatalogEntries || [selectedGPCatalogEntries count] == 0) return;
    
    GPCatalog * selectedGPCatalog = selectedGPCatalogEntries[0];
    
    NSArray * selection = self.priceListController.selectedObjects;
    if (!selection || [selection count] == 0) return;
    
    PriceList * selectedPriceList = selection[0];
    
    NSArray * existingNodes = [[self valuationPerFormatController] arrangedObjects];
    
    // If no nodes exist, create from scratch.
    if ([existingNodes count] == 0) {
        NSMutableArray * l1Valuations = [NSMutableArray arrayWithCapacity:0];
        
        // If the level 1 valuation entries do not exist, create them.
        for (StampFormat * stampFormat in selectedGPCatalog.allowedStampFormats) {
            Valuation * l1Valuation = [NSEntityDescription insertNewObjectForEntityForName:@"Valuation" inManagedObjectContext:self.managedObjectContext];
            
            l1Valuation.gpCatalog = selectedGPCatalog;
            l1Valuation.stampFormat = stampFormat;
            l1Valuation.priceList = selectedPriceList;
            l1Valuation.decisionLevel = @(GPDocument.VALUATION_LEVEL_FORMAT);
            
            [l1Valuations addObject:l1Valuation];
        }
        
        [self.valuationPerFormatController setContent:l1Valuations];
    }
    else {
        NSMutableSet * nodes = [NSMutableSet setWithCapacity:0];
        [nodes addObjectsFromArray:existingNodes];
        
        // Determine which nodes to remove.
        for (Valuation * existingNode in existingNodes) {
            bool needToRemove = YES;
            
            for (StampFormat * stampFormat in selectedGPCatalog.allowedStampFormats) {
                if ([stampFormat isEqualTo:existingNode.stampFormat]) {
                    needToRemove = NO;
                    break;
                }
            }
            
            if (needToRemove) {
                [nodes removeObject:existingNode];
                [self.managedObjectContext deleteObject:existingNode];
            }
        }
        
        // Determine which nodes to add.
        for (StampFormat * stampFormat in selectedGPCatalog.allowedStampFormats) {
            bool needToAdd = YES;
            
            for (Valuation * existingNode in existingNodes) {
                if ([stampFormat isEqualTo:existingNode.stampFormat]) {
                    needToAdd = NO;
                    break;
                }
            }
            
            if (needToAdd) {
                Valuation * l1Valuation = [NSEntityDescription insertNewObjectForEntityForName:@"Valuation" inManagedObjectContext:self.managedObjectContext];
                
                l1Valuation.gpCatalog = selectedGPCatalog;
                l1Valuation.stampFormat = stampFormat;
                l1Valuation.priceList = selectedPriceList;
                l1Valuation.decisionLevel = @(GPDocument.VALUATION_LEVEL_FORMAT);
                
                [nodes addObject:l1Valuation];
            }
        }
        
        [self.valuationPerFormatController setContent:[nodes allObjects]];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAllValuationNodesForGPCatalog:(id)sender {
    NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
    if (!selectedGPCatalogEntries || [selectedGPCatalogEntries count] == 0) return;
    
    GPCatalog * selectedGPCatalog = selectedGPCatalogEntries[0];
    
    NSFetchRequest * valuationFetch = [NSFetchRequest fetchRequestWithEntityName:@"Valuation"];
    [valuationFetch setPredicate:[NSPredicate predicateWithFormat:@"gpCatalog.gp_catalog_number like %@", selectedGPCatalog.gp_catalog_number]];
    
    NSArray * valuationNodes = [self.managedObjectContext executeFetchRequest:valuationFetch error:nil];
    if (valuationNodes && [valuationNodes count] > 0) {
        for (Valuation * node in valuationNodes)
            [self.managedObjectContext deleteObject:node];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
    if (!selectedGPCatalogEntries || [selectedGPCatalogEntries count] == 0) return;
    
    // Always clear the Valuation data when the GPCatalog selection changes.
    [self.valuationPerFormatController setContent:nil];
    
    if ([[[self.gpCatalogDetailTabs selectedTabViewItem] identifier] isEqualToString:@"11"]) {
        GPCatalog * selectedGPCatalog = selectedGPCatalogEntries[0];
        
        NSArray * selection = self.priceListController.selectedObjects;
        if (!selection || [selection count] == 0) return;
        
        // Get the selected valation catagory/price list
        // (note: these are shared accross GPCatalog entries.
        PriceList * selectedPriceList = selection[0];
        
        // Fetch the valuation level 1 entries for this GPCatalog and price list.
        NSFetchRequest * valuationLevel1Fetch = [NSFetchRequest fetchRequestWithEntityName:@"Valuation"];
        [valuationLevel1Fetch setPredicate:[NSPredicate predicateWithFormat:@"gpCatalog.gp_catalog_number like %@ and decisionLevel==%ld and priceList.name like %@", selectedGPCatalog.gp_catalog_number, GPDocument.VALUATION_LEVEL_FORMAT, selectedPriceList.name]];
        
        NSArray * formatValues = [self.managedObjectContext executeFetchRequest:valuationLevel1Fetch error:nil];
        if (formatValues && [formatValues count] > 0) {
            [self.valuationPerFormatController setContent:formatValues];
        }
    }
}

@end
