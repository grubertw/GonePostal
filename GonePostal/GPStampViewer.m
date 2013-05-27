//
//  GPStampViewer.m
//  GonePostal
//
//  Created by Travis Gruber on 3/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampViewer.h"
#import "GPStampDetail.h"
#import "Stamp.h"
#import "GPAddStampController.h"
#import "GPDocument.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFormatSearch.h"
#import "GPLocationSearch.h"
#import "GPCustomSearch.h"

@interface GPStampViewer ()
@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFormatSearch * formatSearchController;
@property (strong, nonatomic) GPLocationSearch * locationSearchController;

@property (strong, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (weak, nonatomic) IBOutlet NSTableView * stampsTable;
@property (strong, nonatomic) IBOutlet NSArrayController * stampsController;

@property (strong, nonatomic) NSPanel * chooseSellListPanel;
@property (weak, nonatomic) IBOutlet NSView * chooseSellListView;
@property (strong, nonatomic) IBOutlet NSArrayController * chooseSellListController;

@property (strong, nonatomic) IBOutlet NSPanel * manageWantSellPanel;
@property (weak, nonatomic) IBOutlet NSTextField * manageWantSellLabel;
@property (strong, nonatomic) IBOutlet NSArrayController * wantSellListsController;
@property (nonatomic) BOOL inManageWantLists;

@end

@implementation GPStampViewer

- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:4];
        
    if (self.countrySearchController.predicate != nil) {
        [predicateArray addObject:self.countrySearchController.predicate];
    }
    
    if (self.sectionSearchController.predicate != nil) {
        [predicateArray addObject:self.sectionSearchController.predicate];
    }
    
    if (self.formatSearchController.predicate != nil) {
        [predicateArray addObject:self.formatSearchController.predicate];
    }
    
    if (self.locationSearchController.predicate != nil) {
        [predicateArray addObject:self.locationSearchController.predicate];
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
    
    [self.document saveInPlace];
    
    // refilter the stamp Data.
    self.currSearch = self.assistedSearch.predicate;
    [self refilterStamps];
}

- (id)initWithCollection:(GPCollection *)myCollection assistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate formatSearch:(NSPredicate *)formatsPredicate locationSearch:(NSPredicate *)locationsPredicate {
    
    self = [super initWithWindowNibName:@"GPStampViewer"];
    if (self) {
        _myCollection = myCollection;
        _managedObjectContext = myCollection.managedObjectContext;
        
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _formatsPredicate = formatsPredicate;
        _locationsPredicate = locationsPredicate;
        
        NSSortDescriptor *stampSort = [[NSSortDescriptor alloc] initWithKey:@"gp_stamp_number" ascending:YES];
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _stampSortDescriptors = @[stampSort, formatSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
        NSSortDescriptor *wantSellListsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _wantSellListsSortDescriptors = @[wantSellListsSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:YES];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:YES];
        _formatSearchController = [[GPFormatSearch alloc] initWithPredicate:formatsPredicate];
        _locationSearchController = [[GPLocationSearch alloc] initWithPredicate:locationsPredicate];
        
        _inManageWantLists = YES;
        _inStampCollection = YES;
        _inItemsSold = NO;
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
    
    self.formatSearchController.panel = [[NSPanel alloc] initWithContentRect:self.formatSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.formatSearchController.panel setContentView:self.formatSearchController.view];
    
    self.locationSearchController.panel = [[NSPanel alloc] initWithContentRect:self.locationSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.locationSearchController.panel setContentView:self.locationSearchController.view];
    
    // Setup other sheets.
    self.chooseSellListPanel = [[NSPanel alloc] initWithContentRect:self.chooseSellListView.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.chooseSellListPanel setContentView:self.chooseSellListView];
    
    // Fetch the stamps, based on the parsed predicate information performed
    // by the search controllers.
    self.currSearch = self.assistedSearch.predicate;
    [self refilterStamps];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.myCollection.name;
}

- (void)refilterStamps {
    [self.stampsController setFilterPredicate:self.currSearch];
    [self.stampsController rearrangeObjects];
}

-(IBAction)showStampDetail:(NSButton *)sender {
    NSInteger row = [self.stampsTable rowForView:sender];
    Stamp * stamp = self.stampsController.arrangedObjects[row];
    
    GPStampDetail * sd = [[GPStampDetail alloc] initWithStamp:stamp isExample:NO];
    [self.document addWindowController:sd];
    [sd.window makeKeyAndOrderFront:sender];
}

- (IBAction)openAddFromGPCatalog:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.myCollection operatingMode:2];
    
    GPDocument * doc = self.document;
    [doc addWindowController:addStampController];
    [addStampController.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddCompositeEditor:(id)sender {
    
}

- (IBAction)openAddSetChooser:(id)sender {
    
}

- (IBAction)openLocator:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.myCollection operatingMode:1];
    
    [self.document addWindowController:addStampController];
    [addStampController.window makeKeyAndOrderFront:self];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.countrySearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.sectionSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openFormatsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.formatSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openLocationsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.locationSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [self updateCurrentSearch];
}

- (IBAction)editCustomSearch:(id)sender {
    GPCustomSearch * customSearchController = [[GPCustomSearch alloc] initWithStoredSearchIdentifier:@(CUSTOM_STAMP_SEARCH_ID)];
    [self.document addWindowController:customSearchController];
    [customSearchController.window makeKeyAndOrderFront:sender];
}

- (IBAction)executeCustomSearch:(id)sender {
    if (!self.currCustomSearch || !self.currCustomSearch.predicate) return;
    
    self.currSearch = self.currCustomSearch.predicate;
    [self refilterStamps];
}

- (IBAction)closeChildren:(id)sender {
    
}

- (IBAction)manageWantLists:(id)sender {
    self.inManageWantLists = YES;
    
    [self.manageWantSellLabel setStringValue:@"Manage want lists."];
    [self.wantSellListsController setContent:self.myCollection.wantLists];
    
    [self.manageWantSellPanel makeKeyAndOrderFront:sender];
}

- (IBAction)manageSellLists:(id)sender {
    self.inManageWantLists = NO;
    
    [self.manageWantSellLabel setStringValue:@"Manage sell lists"];
    [self.wantSellListsController setContent:self.myCollection.sellLists];
    
    [self.manageWantSellPanel makeKeyAndOrderFront:sender];
}

- (IBAction)addToSellList:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.chooseSellListPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)addToSelectedSellList:(id)sender {
    NSArray * selectedSellList = [self.chooseSellListController selectedObjects];
    if (!selectedSellList) return;
    
    GPCollection * sellList = selectedSellList[0];
    
    NSArray * selectedStamps = [self.stampsController selectedObjects];
    if (!selectedStamps) return;
    
    for (Stamp * stamp in selectedStamps) {
        [sellList addStampsObject:stamp];
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.chooseSellListPanel];
    [self.chooseSellListPanel close];
}

- (IBAction)acquired:(id)sender {
    NSArray * selectedStamps = [self.stampsController selectedObjects];
    
    for (Stamp * stamp in selectedStamps) {
        [self.myCollection.wantTarget addStampsObject:stamp];
        [self.myCollection removeStampsObject:stamp];
    }
}

- (IBAction)sold:(id)sender {
    NSArray * selectedStamps = [self.stampsController selectedObjects];
    if (!selectedStamps || ([selectedStamps count] == 0)) return;
    
    NSFetchRequest * collectionFetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCollection"];
    NSPredicate * soldListSearch = [NSPredicate predicateWithFormat:@"type == 4"];
    [collectionFetch setPredicate:soldListSearch];
    
    NSArray * results = [self.managedObjectContext executeFetchRequest:collectionFetch error:nil];
    if (results && ([results count] == 1)) {
        GPCollection * soldList = results[0];
        
        for (Stamp * stamp in selectedStamps) {
            [soldList addStampsObject:stamp];
            [self.myCollection removeStampsObject:stamp];
            
            GPCollection * sellTarget = self.myCollection.sellTarget;
            if (sellTarget) {
                [sellTarget removeStampsObject:stamp];
            }
            
            for (GPCollection * sellList in self.myCollection.sellLists) {
                [sellList removeStampsObject:stamp];
            }
        }
    }
}

- (IBAction)viewSold:(id)sender {
    self.inItemsSold = YES;
    self.inStampCollection = NO;
    
    NSFetchRequest * collectionFetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCollection"];
    NSPredicate * soldListSearch = [NSPredicate predicateWithFormat:@"type == 4"];
    [collectionFetch setPredicate:soldListSearch];
    
    NSArray * results = [self.managedObjectContext executeFetchRequest:collectionFetch error:nil];
    if (results && ([results count] == 1)) {
        GPCollection * soldList = results[0];
        [self.stampsController setContent:soldList.stamps];
        
        [self.stampsTable setBackgroundColor:[NSColor colorWithDeviceRed:0.75 green:0 blue:0 alpha:0.2]];
    }
}

- (IBAction)addWantSellList:(id)sender {
    GPCollection * newList = [NSEntityDescription insertNewObjectForEntityForName:@"GPCollection" inManagedObjectContext:self.managedObjectContext];
    
    if (self.inManageWantLists) {
        [newList setName:@"New Want List"];
        [self.myCollection addWantListsObject:newList];
        newList.wantTarget = self.myCollection;
        newList.type = @(GP_COLLECTION_TYPE_WANT_LIST);
    }
    else {
        [newList setName:@"New Sell List"];
        [self.myCollection addSellListsObject:newList];
        newList.sellTarget = self.myCollection;
        newList.type = @(GP_COLLECTION_TYPE_SELL_LIST);
    }
    
    [self.wantSellListsController addObject:newList];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeWantSellList:(id)sender {
    [self.wantSellListsController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)viewWantSellList:(id)sender {
    NSArray * selection = self.wantSellListsController.selectedObjects;
    if (!selection || ([selection count] == 0)) return;
    
    GPCollection * selectedCollection = self.wantSellListsController.selectedObjects[0];
    [self setMyCollection:selectedCollection];
    [self.stampsController setContent:selectedCollection.stamps];
    
    if (self.inManageWantLists) {
        [self.stampsTable setBackgroundColor:[NSColor colorWithDeviceRed:0 green:0.9 blue:0 alpha:0.1]];
        self.inItemsSold = YES;
    }
    else {
        [self.stampsTable setBackgroundColor:[NSColor colorWithDeviceRed:0.9 green:0 blue:0 alpha:0.1]];
    }
    
    [self.manageWantSellPanel orderOut:sender];
    self.inStampCollection = NO;
}

- (IBAction)returnToCollection:(id)sender {
    if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_WANT_LIST)]) {
        [self setMyCollection:self.myCollection.wantTarget];
    }
    else if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_SELL_LIST)]) {
        [self setMyCollection:self.myCollection.sellTarget];
    }
    
    [self.stampsController setContent:self.myCollection.stamps];
    
    [self.stampsTable setBackgroundColor:[NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.1]];
    
    self.inStampCollection = YES;
    self.inItemsSold = NO;
}

- (IBAction)deleteStamp:(id)sender {
    [self.stampsController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
