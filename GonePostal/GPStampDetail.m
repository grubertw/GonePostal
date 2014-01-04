//
//  GPStampDetail.m
//  GonePostal
//
//  Created by Travis Gruber on 4/13/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampDetail.h"
#import "GPCatalogDetail.h"
#import "GPDocument.h"
#import "GPCatalog.h"
#import "GPPlateNumberChooser.h"
#import "GPCachetChooser.h"
#import "GPBureauPrecancelChooser.h"
#import "GPLocalPrecancelChooser.h"
#import "GPPerfinChooser.h"
#import "GPValuationCalculator.h"
#import "PlateNumber.h"
#import "Cachet.h"
#import "BureauPrecancel.h"
#import "LocalPrecancel.h"
#import "Perfin.h"
#import "PlateUsage.h"
#import "StampFormat.h"

@interface GPStampDetail ()
@property (weak, nonatomic) IBOutlet NSScrollView * stampPicsScrollView;
@property (weak, nonatomic) IBOutlet NSView * stampPicsScrollContent;

@property (weak, nonatomic) IBOutlet NSTabView * sideTabs;
@property (strong, nonatomic) IBOutlet NSTabViewItem * cachetTab;
@property (strong, nonatomic) IBOutlet NSTabViewItem * platesTab;
@property (strong, nonatomic) IBOutlet NSTabViewItem * perfinsTab;

@property (weak, nonatomic) IBOutlet NSTabView * bottomTabs;
@property (weak, nonatomic) IBOutlet NSTabViewItem * historyAndStorageTab;
@property (weak, nonatomic) IBOutlet NSTabViewItem * saleHistoryTab;
@property (weak, nonatomic) IBOutlet NSTabViewItem * sellListsTab;

@property (weak, nonatomic) IBOutlet NSTextField *plateInfoField;

@property (weak, nonatomic) IBOutlet NSTextField *valuationDescription;

@property (strong, nonatomic) IBOutlet NSArrayController * saleHistoryController;
@property (strong, nonatomic) IBOutlet NSArrayController * sellListsController;

@property (nonatomic) BOOL isExample;

@property (strong, nonatomic) GPPlateNumberChooser * plateNumberChooser;
@property (strong, nonatomic) GPCachetChooser * cachetChooser;
@property (strong, nonatomic) GPBureauPrecancelChooser * bureauPrecancelChooser;
@property (strong, nonatomic) GPLocalPrecancelChooser * localPrecancelChooser;
@property (strong, nonatomic) GPPerfinChooser * perfinChooser;

@property (strong, nonatomic) GPCatalogDetail * catalogDetail;
@property (nonatomic) BOOL catalogDetailIsOpen;

@property (strong, nonatomic) GPDocument * doc;
@end

@implementation GPStampDetail

- (id)initWithStamp:(Stamp *)stamp isExample:(BOOL)isExample {
    self = [super initWithWindowNibName:@"GPStampDetail"];
    if (self) {
        _managedObjectContext = stamp.managedObjectContext;
        _stamp = stamp;
        _isExample = isExample;
        
        // Initialize the sort descriptors
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _formatSortDescriptors = @[formatSort];
        
        NSSortDescriptor *centeringSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _centeringSortDescriptors = @[centeringSort];
        
        NSSortDescriptor *soundnessSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _soundnessSortDescriptors = @[soundnessSort];
        
        NSSortDescriptor *gradeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _gradeSortDescriptors = @[gradeSort];
        
        NSSortDescriptor *cancelQualitySort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _cancelQualitySortDescriptors = @[cancelQualitySort];
        
        NSSortDescriptor *gumcondSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _gumConditionSortDescriptors = @[gumcondSort];
        
        NSSortDescriptor *hingedSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _hingedSortDescriptors = @[hingedSort];
        
        NSSortDescriptor *dealerSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _dealerSortDescriptors = @[dealerSort];
        
        NSSortDescriptor *lotSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _lotSortDescriptors = @[lotSort];
        
        NSSortDescriptor *locationSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _locationSortDescriptors = @[locationSort];
        
        NSSortDescriptor *mountSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _mountSortDescriptors = @[mountSort];
        
        NSSortDescriptor *saleHistorySort = [[NSSortDescriptor alloc] initWithKey:@"dateSold" ascending:NO];
        _saleHistorySortDescriptors = @[saleHistorySort];
        
        NSSortDescriptor *sellListsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sellListsSortDescriptors = @[sellListsSort];
        
        _sellListsFilter = [NSPredicate predicateWithFormat:@"type == %ld", GP_COLLECTION_TYPE_SELL_LIST];
        
        // Intialize the chooser drawers.
        _plateNumberChooser = [[GPPlateNumberChooser alloc] initAsDrawer:YES modifyingStamp:self.stamp];
        _cachetChooser = [[GPCachetChooser alloc] initAsDrawer:YES modifyingStamp:self.stamp];
        _bureauPrecancelChooser = [[GPBureauPrecancelChooser alloc] initAsDrawer:YES modifyingStamp:self.stamp];
        _localPrecancelChooser = [[GPLocalPrecancelChooser alloc] initAsDrawer:YES modifyingStamp:self.stamp];
        _perfinChooser = [[GPPerfinChooser alloc] initAsDrawer:YES modifyingStamp:self.stamp];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        
        // Initialize catalog detail as a drawer
        _catalogDetail = [[GPCatalogDetail alloc] initWithGPCatalog:self.stamp.gpCatalog];
        _catalogDetailIsOpen = NO;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.stampPicsScrollView setDocumentView:self.stampPicsScrollContent];
    
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.stampPicsScrollView documentView] frame]) -
                                    [[self.stampPicsScrollView contentView] bounds].size.height);
    [[self.stampPicsScrollView documentView] scrollPoint:newOrigin];
    
    // Place the chooser views into drawers which can be opened by this window controller.
    self.plateNumberChooser.drawer = [[NSDrawer alloc] initWithContentSize:self.plateNumberChooser.view.bounds.size preferredEdge:NSMaxXEdge];
    [self.plateNumberChooser.drawer setParentWindow:self.window];
    [self.plateNumberChooser.drawer setContentView:self.plateNumberChooser.view];
    [self.plateNumberChooser setPlateInfoField:self.plateInfoField];
    [self.plateNumberChooser setGpCatalog:self.stamp.gpCatalog];
    [self.plateNumberChooser formatPlateInfo];
    
    self.cachetChooser.drawer = [[NSDrawer alloc] initWithContentSize:self.cachetChooser.view.bounds.size preferredEdge:NSMaxXEdge];
    [self.cachetChooser.drawer setParentWindow:self.window];
    [self.cachetChooser.drawer setContentView:self.cachetChooser.view];
    [self.cachetChooser setSelectedGPCatalog:self.stamp.gpCatalog];
    
    self.bureauPrecancelChooser.drawer = [[NSDrawer alloc] initWithContentSize:self.bureauPrecancelChooser.view.bounds.size preferredEdge:NSMaxXEdge];
    [self.bureauPrecancelChooser.drawer setParentWindow:self.window];
    [self.bureauPrecancelChooser.drawer setContentView:self.bureauPrecancelChooser.view];
    [self.bureauPrecancelChooser setSelectedGPCatalog:self.stamp.gpCatalog];
    
    self.localPrecancelChooser.drawer = [[NSDrawer alloc] initWithContentSize:self.localPrecancelChooser.view.bounds.size preferredEdge:NSMaxXEdge];
    [self.localPrecancelChooser.drawer setParentWindow:self.window];
    [self.localPrecancelChooser.drawer setContentView:self.localPrecancelChooser.view];
    
    self.perfinChooser.drawer = [[NSDrawer alloc] initWithContentSize:self.perfinChooser.view.bounds.size preferredEdge:NSMaxXEdge];
    [self.perfinChooser.drawer setParentWindow:self.window];
    [self.perfinChooser.drawer setContentView:self.perfinChooser.view];
    
    // Place catalog detail as a bottom opening drawer
    self.catalogDetail.drawer = [[NSDrawer alloc] initWithContentSize:self.catalogDetail.view.bounds.size preferredEdge:NSMaxYEdge];
    [self.catalogDetail.drawer setParentWindow:self.window];
    [self.catalogDetail.drawer setContentView:self.catalogDetail.view];
    
    // Show the correct tabs for example stamps vs stamps in a collection.
    if (self.isExample) {
        [self.bottomTabs removeTabViewItem:self.historyAndStorageTab];
        [self.bottomTabs removeTabViewItem:self.sellListsTab];
    }
    else {
        [self.bottomTabs removeTabViewItem:self.saleHistoryTab];
    }
    
    // Register this object as a key-value observer of the stamp
    // (used to show and hide tabs, based on the format)
    [self.stamp addObserver:self forKeyPath:@"format" options:NSKeyValueObservingOptionNew context:nil];
    
    [self resequenceTabsForStamp:self.stamp];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([keyPath isEqualToString:@"format"] && [object isMemberOfClass:[Stamp class]]) {
        Stamp * stamp = (Stamp *)object;
        [self resequenceTabsForStamp:stamp];
    }
}

- (void)resequenceTabsForStamp:(Stamp *)stamp {
    NSInteger tabIndexToInsert = 0;
    
    // Show or hide the tabs, based on the display BOOLs of the StampFormat.
    if (stamp.format.displayCachetInfo) {
        if ([self.sideTabs indexOfTabViewItem:self.cachetTab] == NSNotFound) {
            [self.sideTabs insertTabViewItem:self.cachetTab atIndex:tabIndexToInsert];
        }
        tabIndexToInsert++;
    }
    else {
        if ([self.sideTabs indexOfTabViewItem:self.cachetTab] != NSNotFound) {
            [self.sideTabs removeTabViewItem:self.cachetTab];
        }
    }
    
    if (stamp.format.displayPlateInfo) {
        if ([self.sideTabs indexOfTabViewItem:self.platesTab] == NSNotFound) {
            [self.sideTabs insertTabViewItem:self.platesTab atIndex:tabIndexToInsert];
        }
        tabIndexToInsert++;
    }
    else {
        if ([self.sideTabs indexOfTabViewItem:self.platesTab] != NSNotFound) {
            [self.sideTabs removeTabViewItem:self.platesTab];
        }
    }
    
    if (stamp.format.displayPerfinInfo) {
        if ([self.sideTabs indexOfTabViewItem:self.perfinsTab] == NSNotFound) {
            [self.sideTabs insertTabViewItem:self.perfinsTab atIndex:tabIndexToInsert];
        }
        tabIndexToInsert++;
    }
    else {
        if ([self.sideTabs indexOfTabViewItem:self.perfinsTab] != NSNotFound) {
            [self.sideTabs removeTabViewItem:self.perfinsTab];
        }
    }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.stamp.gpCatalog.gp_catalog_number;
}

- (IBAction)showCatalogInfo:(id)sender {
    if (self.catalogDetailIsOpen) {
        self.catalogDetailIsOpen = NO;
        [self.catalogDetail.drawer close];
    }
    else {
        self.catalogDetailIsOpen = YES;
        [self.catalogDetail.drawer open:sender];
    }
}

- (IBAction)chooseCachet:(id)sender {
    [self.cachetChooser.drawer open:sender];
}

- (IBAction)choosePlateInfo:(id)sender {
    [self.plateNumberChooser clearManualPlateEntry];
    [self.plateNumberChooser.drawer open:sender];
}

- (IBAction)chooseBureauPrecancel:(id)sender {
    [self.bureauPrecancelChooser.drawer open:sender];
}

- (IBAction)chooseLocalPrecancel:(id)sender {
    [self.localPrecancelChooser.drawer open:sender];
}

- (IBAction)choosePerfin:(id)sender {
    [self.perfinChooser.drawer open:sender];
}

- (IBAction)addSaleHistory:(id)sender {
    [self.saleHistoryController insert:sender];
}

- (IBAction)removeSaleHistory:(id)sender {
    [self.saleHistoryController remove:sender];
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.default_picture" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_1" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_2" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_3" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_4" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_5" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_6" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_6 = fileName;
}

- (IBAction)removeFromSellList:(id)sender {
    [self.sellListsController remove:sender];
}

- (IBAction)recalculateCatalogValue:(id)sender {
    NSString * valuationDesc = [GPValuationCalculator deriveCatalogValueOfStamp:self.stamp];
    
    [self.valuationDescription setStringValue:valuationDesc];
}

- (void)windowWillClose:(NSNotification *)notification {
    [self.stamp removeObserver:self forKeyPath:@"format"];
}

- (IBAction)done:(id)sender {
    [self.window performClose:sender];
}

@end
