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
#import "GPSetChooser.h"
#import "GPDocument.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFormatSearch.h"
#import "GPLocationSearch.h"
#import "GPCustomSearch.h"
#import "Stamp+CreateComposite.h"
#import "AlternateCatalog.h"
#import "AlternateCatalogName.h"

@interface GPStampViewer ()
@property (strong, nonatomic) NSColor * COLLECTION_COLOR;
@property (strong, nonatomic) NSColor * CHILDREN_COLOR;
@property (strong, nonatomic) NSColor * WANT_LIST_COLOR;
@property (strong, nonatomic) NSColor * SELL_LIST_COLOR;
@property (strong, nonatomic) NSColor * SOLD_LIST_COLOR;

@property (strong, nonatomic) NSString * windowName;

@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFormatSearch * formatSearchController;
@property (strong, nonatomic) GPLocationSearch * locationSearchController;

@property (strong, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (weak, nonatomic) IBOutlet NSTableView * stampsTable;
@property (strong, nonatomic) IBOutlet NSArrayController * stampsController;
@property (strong, nonatomic) id currStampsContainer;

@property (weak, nonatomic) IBOutlet NSPopUpButton * gotoPopup;
@property (weak, nonatomic) IBOutlet NSTextField * gotoField;

@property (strong, nonatomic) NSPanel * createCompositePanel;
@property (weak, nonatomic) IBOutlet NSView * createCompositeView;
@property (weak, nonatomic) IBOutlet NSButton * setOrIntegralCompositeCheckBox;

@property (weak, nonatomic) IBOutlet NSTextField * wantListTitle;

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
        _COLLECTION_COLOR = [NSColor colorWithDeviceRed:1 green:1 blue:1 alpha:0.1];
        _CHILDREN_COLOR = [NSColor colorWithDeviceRed:0.75 green:0.75 blue:1 alpha:0.2];
        _WANT_LIST_COLOR = [NSColor colorWithDeviceRed:0 green:0.9 blue:0 alpha:0.1];
        _SELL_LIST_COLOR = [NSColor colorWithDeviceRed:0.7 green:0 blue:0 alpha:0.1];
        _SOLD_LIST_COLOR = [NSColor colorWithDeviceRed:0.75 green:0 blue:0 alpha:0.2];
        
        
        _myCollection = myCollection;
        _managedObjectContext = myCollection.managedObjectContext;
        
        _windowName = self.myCollection.name;
        
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
    self.createCompositePanel = [[NSPanel alloc] initWithContentRect:self.createCompositeView.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.createCompositePanel setContentView:self.createCompositeView];
    
    self.chooseSellListPanel = [[NSPanel alloc] initWithContentRect:self.chooseSellListView.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.chooseSellListPanel setContentView:self.chooseSellListView];
    
    // Fetch the stamps, based on the parsed predicate information performed
    // by the search controllers.
    [self changeStampContent:self.myCollection];
    self.currSearch = self.assistedSearch.predicate;
    [self refilterStamps];
    
    [self.wantListTitle setHidden:YES];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.windowName;
}

- (void)refilterStamps {
    [self.stampsController setFilterPredicate:self.currSearch];
    [self.stampsController rearrangeObjects];
}

- (void)removeObserversFromContainer {
    if (self.currStampsContainer && [self.currStampsContainer isMemberOfClass:[GPCollection class]]) {
        [self.currStampsContainer removeObserver:self forKeyPath:@"stamps"];
    }
    else if (self.currStampsContainer && [self.currStampsContainer isMemberOfClass:[Stamp class]]) {
        [self.currStampsContainer removeObserver:self forKeyPath:@"children"];
    }
}

- (void)changeStampContent:(id)content {
    [self removeObserversFromContainer];
    
    if ([content isMemberOfClass:[GPCollection class]]) {
        GPCollection * collection = (GPCollection *)content;
        [collection addObserver:self
                     forKeyPath:@"stamps"
                        options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                        context:nil];
        
        [self.stampsController setContent:collection.stamps];
    }
    else if ([content isMemberOfClass:[Stamp class]]) {
        Stamp * composite = (Stamp *)content;
        [composite addObserver:self
                    forKeyPath:@"children"
                       options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld)
                       context:nil];
        
        [self.stampsController setContent:composite.children];
    }
    
    self.currStampsContainer = content;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isMemberOfClass:[GPCollection class]]) {
        [self.stampsController setContent:((GPCollection *)object).stamps];
    }
    else if ([object isMemberOfClass:[Stamp class]]) {
        [self.stampsController setContent:((Stamp *)object).children];
    }
    
//    if (   ![object isMemberOfClass:[GPCollection class]]
//        && ![object isMemberOfClass:[Stamp class]]) return;
//    
//    NSNumber * changeType = change[NSKeyValueChangeKindKey];
//    if ([changeType isEqualToNumber:@(NSKeyValueChangeInsertion)]) {
//        NSArray *insertedStamps = change[NSKeyValueChangeNewKey];
//        
//        for (Stamp * stamp in insertedStamps) {
//            [self.stampsController addObject:stamp];
//        }
//    }
//    else if ([changeType isEqualToNumber:@(NSKeyValueChangeRemoval)]) {
//        NSArray *removedStamps = change[NSKeyValueChangeOldKey];
//        
//        for (Stamp * stamp in removedStamps) {
//            [self.stampsController removeObject:stamp];
//        }
//    }
}

- (void)controlTextDidChange:(NSNotification *)aNotification {
    NSTextField * textField = aNotification.object;
    
    if ([textField isEqualTo:self.gotoField]) {
        NSArray * entries = self.stampsController.arrangedObjects;
        NSInteger searchType = [[self.gotoPopup selectedItem] tag];
        NSString * typedValue = self.gotoField.stringValue;
        
        NSUInteger foundEntryRow = 0;
        NSRange findOP = {NSNotFound, 0};
        
        for (NSUInteger row=0; row < [entries count]; row++) {
            Stamp * entry = entries[row];
            
            if (searchType == 1) {
                findOP = [entry.gp_stamp_number rangeOfString:typedValue];
            }
            else if (searchType == 2) {
                NSString * altCatalogNumber;
                
                if (!entry.gpCatalog) continue;
                
                for (AlternateCatalog * altCatalog in entry.gpCatalog.alternateCatalogs) {
                    if ([altCatalog.alternateCatalogName.alternate_catalog_name isEqualToString:entry.gpCatalog.defaultCatalogName.alternate_catalog_name]) {
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
        [self.stampsTable selectRowIndexes:changeToSelection byExtendingSelection:NO];
        [self.stampsTable scrollRowToVisible:foundEntryRow];
    }
}

-(IBAction)showStampDetail:(NSButton *)sender {
    NSInteger row = [self.stampsTable rowForView:sender];
    Stamp * stamp = self.stampsController.arrangedObjects[row];
    
    if ([stamp.children count] > 0) {
        self.selectedComposite = stamp;
        
        [self.stampsController setContent:stamp.children];
        [self.stampsTable setBackgroundColor:self.CHILDREN_COLOR];
        
        self.inStampCollection = NO;
        self.inItemsSold = YES;
    }
    else {
        GPStampDetail * sd = [[GPStampDetail alloc] initWithStamp:stamp isExample:NO];
        [self.document addWindowController:sd];
        [sd.window makeKeyAndOrderFront:sender];
    }
}

- (IBAction)openAddFromGPCatalog:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.currStampsContainer operatingMode:2];
    
    GPDocument * doc = self.document;
    [doc addWindowController:addStampController];
    [addStampController.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddCompositeEditor:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [self.managedObjectContext save:nil];
    [app beginSheet:self.createCompositePanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)createComposite:(id)sender {
    NSArray * selectedStamps = [self.stampsController selectedObjects];
    if (!selectedStamps) return;
    
    NSApplication * app = [NSApplication sharedApplication];
    
    NSInteger compositeType;
    if (self.setOrIntegralCompositeCheckBox.state == NSOnState) {
        compositeType = COMPOSITE_TYPE_INTEGRAL;
    }
    else {
        compositeType = COMPOSITE_TYPE_SET;
    }
    
    for (Stamp * stamp in selectedStamps) {
        if ([stamp.children count] > 0) {
            [self.managedObjectContext rollback];
            
            [app endSheet:self.createCompositePanel];
            [self.createCompositePanel close];
            
            NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"A Composite item cannot be placed within another composite.  Please remove the composite item from your selection."];
            
            [alertSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            return;
        }
        
        [self.myCollection removeStampsObject:stamp];
    }
    
    Stamp * composite = [Stamp createCompositeType:compositeType fromSet:[NSSet setWithArray:selectedStamps]];
    [self.myCollection addStampsObject:composite];
    
    // End the sheet.
    [app endSheet:self.createCompositePanel];
    [self.createCompositePanel close];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
}

- (IBAction)cancelComposite:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    // End the sheet.
    [app endSheet:self.createCompositePanel];
    [self.createCompositePanel close];
}

- (IBAction)openAddSetChooser:(id)sender {
    GPDocument * doc = [self document];
    [doc loadAssistedSearch:ASSISTED_SETS_BROWSER_SEARCH_ID];
    GPSetChooser * setChooser = [[GPSetChooser alloc] initWithGPCollection:self.myCollection andAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate];
    
    [doc addWindowController:setChooser];
    [setChooser.window makeKeyAndOrderFront:sender];
}

- (IBAction)openLocator:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.currStampsContainer operatingMode:1];
    
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

- (IBAction)editComposite:(id)sender {
    GPStampDetail * sd = [[GPStampDetail alloc] initWithStamp:self.selectedComposite isExample:NO];
    [self.document addWindowController:sd];
    [sd.window makeKeyAndOrderFront:sender];
}

- (IBAction)closeChildren:(id)sender {
    [self changeStampContent:self.myCollection];
    
    if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_WANT_LIST)]) {
        [self.stampsTable setBackgroundColor:self.WANT_LIST_COLOR];
    }
    else if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_SELL_LIST)]) {
        [self.stampsTable setBackgroundColor:self.SELL_LIST_COLOR];
    }
    else if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_ITEMS_SOLD)]) {
        [self.stampsTable setBackgroundColor:self.SOLD_LIST_COLOR];
    }
    else {
        [self.stampsTable setBackgroundColor:self.COLLECTION_COLOR];
        self.inStampCollection = YES;
    }
    
    self.selectedComposite = nil;
    
    self.inItemsSold = NO;
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

- (IBAction)cancelAddToSellList:(id)sender {
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
                continue;
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
        [self changeStampContent:soldList];
        
        [self.stampsTable setBackgroundColor:self.SOLD_LIST_COLOR];
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
    [self changeStampContent:selectedCollection];
    
    if (self.inManageWantLists) {
        [self.stampsTable setBackgroundColor:self.WANT_LIST_COLOR];
        self.inItemsSold = YES;
        [self.wantListTitle setTextColor:[NSColor colorWithDeviceRed:0 green:0.7 blue:0 alpha:1]];
    }
    else {
        [self.stampsTable setBackgroundColor:self.SELL_LIST_COLOR];
        [self.wantListTitle setTextColor:[NSColor colorWithDeviceRed:0.9 green:0 blue:0 alpha:1]];
    }
    
    [self.manageWantSellPanel orderOut:sender];
    self.inStampCollection = NO;
    
    [self.wantListTitle setStringValue:self.myCollection.name];
    [self.wantListTitle setHidden:NO];
}

- (IBAction)cancelViewWantSellList:(id)sender {
    [self.manageWantSellPanel orderOut:sender];
}

- (IBAction)returnToCollection:(id)sender {
    if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_WANT_LIST)]) {
        [self setMyCollection:self.myCollection.wantTarget];
    }
    else if ([self.myCollection.type isEqualToNumber:@(GP_COLLECTION_TYPE_SELL_LIST)]) {
        [self setMyCollection:self.myCollection.sellTarget];
    }
    
    [self changeStampContent:self.myCollection];
    
    [self.stampsTable setBackgroundColor:self.COLLECTION_COLOR];
    
    self.inStampCollection = YES;
    self.inItemsSold = NO;
    [self.wantListTitle setHidden:YES];
    self.selectedComposite = nil;
}

- (IBAction)deleteStamp:(id)sender {
    NSArray * selected = [self.stampsController selectedObjects];
    if (!selected) return;
    
    for (Stamp * stamp in selected) {
        // Check if stamp has children.  If so, make sure the user wants to delete.
        if ([stamp.children count] > 0) {
       
            NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Are you sure you want to delete %@? The composite has %ld children which will also be deleted.", stamp.gp_stamp_number, [stamp.children count]];
            [alertSheet beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(userConfirmedCompositeDelete:returnCode:contextInfo:) contextInfo:(__bridge void *)(stamp)];
            return;
        }
        else if (stamp.parent != nil) {
            [stamp.parent removeChildrenObject:stamp];
        }
        else if (stamp.parent == nil) {
            [self.myCollection removeStampsObject:stamp];
            
            if (self.myCollection.sellTarget) {
                [self.myCollection.sellTarget removeStampsObject:stamp];
            }
            
            for (GPCollection * sellList in self.myCollection.sellLists) {
                [sellList removeStampsObject:stamp];
            }
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (void)userConfirmedCompositeDelete:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertDefaultReturn && contextInfo != nil) {
        Stamp * composite = (__bridge Stamp *)contextInfo;
        
        [self.myCollection removeStampsObject:composite];
        if (self.myCollection.sellTarget) {
            [self.myCollection.sellTarget removeStampsObject:composite];
        }
        
        for (GPCollection * sellList in self.myCollection.sellLists) {
            [sellList removeStampsObject:composite];
        }
        
        [self.managedObjectContext deleteObject:composite];
        
        NSError * error;
        if (![self.managedObjectContext save:&error]) {
            [alert.window orderOut:self];
            NSAlert * errSheet = [NSAlert alertWithError:error];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [self.managedObjectContext undo];
        }
    }
}

- (IBAction)breakDownComposite:(id)sender {
    NSArray * selected = [self.stampsController selectedObjects];
    if (!selected || [selected count] > 1) return;
    
    Stamp * composite = self.stampsController.selectedObjects[0];
    
    if (composite.parentType == nil) {
        NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Selected stamp is not a composite.  Only a composite stamp can be broken down into the collection."];
        
        [alertSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return;
    }
    
    if ([composite.parentType isEqualToNumber:@(COMPOSITE_TYPE_INTEGRAL)]) {
        NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Integral composite %@ cannot be borken down into the collection.  Click remove if you wish to remove this composite from your collection.", composite.gp_stamp_number];
        
        [alertSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return;
    }
   
    NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Composite %@ will be broken down into your collection. %ld stamps will be added.  Are you sure you wish to proceed?", composite.gp_stamp_number, [composite.children count]];
    [alertSheet beginSheetModalForWindow:self.window modalDelegate:self didEndSelector:@selector(userConfirmedCompositeBreakdown:returnCode:contextInfo:) contextInfo:(__bridge void *)(composite)];
}

- (void)userConfirmedCompositeBreakdown:(NSAlert *)alert returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    if (returnCode == NSAlertDefaultReturn && contextInfo != nil) {
        Stamp * composite = (__bridge Stamp *)contextInfo;
        NSSet * children = [[NSSet alloc] initWithSet:[composite children]];
        
        for (Stamp * child in children) {
            [composite removeChildrenObject:child];
            [self.myCollection addStampsObject:child];
            
            if (self.myCollection.sellTarget != nil) {
                [self.myCollection.sellTarget addStampsObject:child];
            }
            
            for (GPCollection * sellList in self.myCollection.sellLists) {
                for (Stamp * stamp in sellList.stamps) {
                    if ([stamp isEqualTo:composite]) {
                        [sellList addStampsObject:child];
                    }
                }
            }
        }
        
        [self.myCollection removeStampsObject:composite];
        [self.managedObjectContext deleteObject:composite];
        
        NSError * error;
        if (![self.managedObjectContext save:&error]) {
            [alert.window orderOut:self];
            NSAlert * errSheet = [NSAlert alertWithError:error];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [self.managedObjectContext undo];
        }
    }
}

- (IBAction)done:(id)sender {
    [self.window performClose:sender];
}

- (void)windowWillClose:(NSNotification *)notification {
    [self removeObserversFromContainer];
}

@end
