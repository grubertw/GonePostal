//
//  GPNewStampPage.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPNewStampPage.h"
#import "GPDocument.h"
#import "Stamp+Create.h"
#import "Stamp+CreateComposite.h"
#import "Stamp+Duplicate.h"
#import "GPPlateNumberChooser.h"
#import "GPCachetChooser.h"
#import "GPBureauPrecancelChooser.h"
#import "GPLocalPrecancelChooser.h"
#import "GPPerfinChooser.h"
#import "PlateNumber.h"
#import "Cachet.h"
#import "BureauPrecancel.h"
#import "LocalPrecancel.h"
#import "Perfin.h"
#import "PlateUsage.h"
#import "StampFormat.h"

@interface GPNewStampPage ()
@property (strong, nonatomic) GPDocument * doc;
@property (strong, nonatomic) GPCollection * collection;

@property (weak, nonatomic) IBOutlet NSBox * cachetBox;
@property (weak, nonatomic) IBOutlet NSBox * platesBox;
@property (weak, nonatomic) IBOutlet NSBox * bureauPrecancelBox;
@property (weak, nonatomic) IBOutlet NSBox * localPrecancelBox;
@property (weak, nonatomic) IBOutlet NSBox * perfinBox;
@property (weak, nonatomic) IBOutlet NSBox * usedConditionBox;
@property (weak, nonatomic) IBOutlet NSBox * historyAndStorageBox;
@property (weak, nonatomic) IBOutlet NSBox * picturesBox;
@property (weak, nonatomic) IBOutlet NSBox * notesBox;

@property (nonatomic) NSRect cachetFrame;
@property (nonatomic) NSRect platesFrame;
@property (nonatomic) NSRect bureauPrecancelFrame;
@property (nonatomic) NSRect localPrecancelFrame;
@property (nonatomic) NSRect perfinFrame;
@property (nonatomic) NSRect conditionFrame;
@property (nonatomic) NSRect historyAndStorageFrame;
@property (nonatomic) NSRect picturesFrame;
@property (nonatomic) NSRect notesFrame;

@property (weak, nonatomic) IBOutlet NSScrollView * scroller;
@property (strong, nonatomic) IBOutlet NSView * scrollContent;
@property (weak, nonatomic) IBOutlet NSTextField *plateInfoField;

@property (weak, nonatomic) IBOutlet NSBox * stampPeriferalsBox;

@property (strong, nonatomic) GPPlateNumberChooser * plateNumberChooser;
@property (strong, nonatomic) GPCachetChooser * cachetChooser;
@property (strong, nonatomic) GPBureauPrecancelChooser * bureauPrecancelChooser;
@property (strong, nonatomic) GPLocalPrecancelChooser * localPrecancelChooser;
@property (strong, nonatomic) GPPerfinChooser * perfinChooser;

@end

@implementation GPNewStampPage


- (id)initWithCollection:(GPCollection *)myCollection {
    self = [super initWithNibName:@"GPNewStampPage" bundle:nil];
    if (self) {
        _collection = myCollection;
        
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
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = _doc.managedObjectContext;
        
        // Create the stamps from the defaults.
        if (self.stamp == nil) {
            self.stamp = [Stamp CreateFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
        }
            
        // Intialize the chooser views.
        _plateNumberChooser = [[GPPlateNumberChooser alloc] initAsDrawer:NO modifyingStamp:self.stamp];
        _cachetChooser = [[GPCachetChooser alloc] initAsDrawer:NO modifyingStamp:self.stamp];
        _bureauPrecancelChooser = [[GPBureauPrecancelChooser alloc] initAsDrawer:NO modifyingStamp:self.stamp];
        _localPrecancelChooser = [[GPLocalPrecancelChooser alloc] initAsDrawer:NO modifyingStamp:self.stamp];
        _perfinChooser = [[GPPerfinChooser alloc] initAsDrawer:NO modifyingStamp:self.stamp];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Initialize the scroller
    [self.scroller setDocumentView:self.scrollContent];
    
    [self.compositeQuantityInput setIntegerValue:1];
    
    // Set the scroller to the top.
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.scroller documentView] frame]) -
                                    [[self.scroller contentView] bounds].size.height);
    [[self.scroller documentView] scrollPoint:newOrigin];
    
    [self.plateNumberChooser loadView];
    [self.cachetChooser loadView];
    [self.localPrecancelChooser loadView];
    [self.bureauPrecancelChooser loadView];
    [self.perfinChooser loadView];
    
    [self.plateNumberChooser setPlateInfoField:self.plateInfoField];
    [self.plateNumberChooser formatPlateInfo];
    
    // Register this object as a key-value observer of the stamp
    // (used to show and hide boxes, based on the format)
    [self.stamp addObserver:self forKeyPath:@"format" options:NSKeyValueObservingOptionNew context:nil];
    [self.stamp addObserver:self forKeyPath:@"mint_used" options:NSKeyValueObservingOptionNew context:nil];
    
    self.cachetFrame = [self.cachetBox frame];
    self.platesFrame = [self.platesBox frame];
    self.bureauPrecancelFrame = [self.bureauPrecancelBox frame];
    self.localPrecancelFrame = [self.localPrecancelBox frame];
    self.perfinFrame = [self.perfinBox frame];
    self.conditionFrame = [self.usedConditionBox frame];
    self.historyAndStorageFrame = [self.historyAndStorageBox frame];
    self.picturesFrame = [self.picturesBox frame];
    self.notesFrame = [self.notesBox frame];
}

- (void)setSelectedGPCatalog:(GPCatalog *)gpCatalog {
    _selectedGPCatalog = gpCatalog;
    
    [self.plateNumberChooser setGpCatalog:gpCatalog];
    [self.cachetChooser setSelectedGPCatalog:gpCatalog];
    [self.bureauPrecancelChooser setSelectedGPCatalog:gpCatalog];
    
    [self.stamp setGpCatalog:gpCatalog];
    
    // Copy the GPID from the catalog into the stamp.
    [self.stamp setGp_stamp_number:gpCatalog.gp_catalog_number];
    
    [self showHideBoxesForStamp:self.stamp];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isMemberOfClass:[Stamp class]]) {
        Stamp * stamp = (Stamp *)object;
        [self showHideBoxesForStamp:stamp];
    }
}

- (void)showHideBoxesForStamp:(Stamp *)stamp {
    CGFloat top = self.cachetFrame.origin.y + self.cachetFrame.size.height;
    CGFloat currY = top;
    
    if (stamp.format && stamp.format.displayCachetInfo) {
        [self.cachetBox setFrame:self.cachetFrame];
        currY -= self.cachetFrame.size.height;
    }
    else {
        [self.cachetBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if (stamp.format.displayPlateInfo) {
        currY -= self.platesFrame.size.height;
        [self.platesBox setFrame:NSMakeRect(self.platesFrame.origin.x,
                                            currY,
                                            self.platesFrame.size.width,
                                            self.platesFrame.size.height)];
    }
    else {
        [self.platesBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if (stamp.format && stamp.format.displayBureauPrecancelInfo) {
        currY -= self.bureauPrecancelFrame.size.height;
        [self.bureauPrecancelBox setFrame:NSMakeRect(self.bureauPrecancelFrame.origin.x,
                                            currY,
                                            self.bureauPrecancelFrame.size.width,
                                            self.bureauPrecancelFrame.size.height)];
    }
    else {
        [self.bureauPrecancelBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if (stamp.format && stamp.format.displayLocalPrecancelInfo) {
        currY -= self.localPrecancelFrame.size.height;
        [self.localPrecancelBox setFrame:NSMakeRect(self.localPrecancelFrame.origin.x,
                                            currY,
                                            self.localPrecancelFrame.size.width,
                                            self.localPrecancelFrame.size.height)];
    }
    else {
        [self.localPrecancelBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if (stamp.format && stamp.format.displayPerfinInfo) {
        currY -= self.perfinFrame.size.height;
        [self.perfinBox setFrame:NSMakeRect(self.perfinFrame.origin.x,
                                            currY,
                                            self.perfinFrame.size.width,
                                            self.perfinFrame.size.height)];
    }
    else {
        [self.perfinBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if ([stamp.mint_used isEqualToNumber:@(NO)]) {
        currY -= self.conditionFrame.size.height;
        [self.usedConditionBox setFrame:NSMakeRect(self.conditionFrame.origin.x,
                                            currY,
                                            self.conditionFrame.size.width,
                                            self.conditionFrame.size.height)];
    }
    else {
        [self.usedConditionBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    currY -= [self.historyAndStorageBox frame].size.height;
    [self.historyAndStorageBox setFrame:NSMakeRect(self.historyAndStorageFrame.origin.x,
                                                   currY,
                                                   self.historyAndStorageFrame.size.width,
                                                   self.historyAndStorageFrame.size.height)];
    
    currY -= [self.picturesBox frame].size.height;
    [self.picturesBox setFrame:NSMakeRect(self.picturesFrame.origin.x,
                                          currY,
                                          self.picturesFrame.size.width,
                                          self.picturesFrame.size.height)];
    
    currY -= [self.notesBox frame].size.height;
    [self.notesBox setFrame:NSMakeRect(self.notesFrame.origin.x,
                                       currY,
                                       self.notesFrame.size.width,
                                       self.notesFrame.size.height)];

    [self.scrollContent setNeedsDisplay:YES];
}

- (IBAction)addPlate:(id)sender {
    if ([self.plateNumberChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    [self.plateNumberChooser clearManualPlateEntry];
    
    [self.stampPeriferalsBox addSubview:self.plateNumberChooser.view];
    [self.plateNumberChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseBureauPrecancel:(id)sender {
    if ([self.bureauPrecancelChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    
    [self.stampPeriferalsBox addSubview:self.bureauPrecancelChooser.view];
    [self.bureauPrecancelChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseCachet:(id)sender {
    if ([self.cachetChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    
    [self.stampPeriferalsBox addSubview:self.cachetChooser.view];
    [self.cachetChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseLocalPrecancel:(id)sender {
    if ([self.localPrecancelChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    
    [self.stampPeriferalsBox addSubview:self.localPrecancelChooser.view];
    [self.localPrecancelChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)choosePerfin:(id)sender {
    if ([self.perfinChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    
    [self.stampPeriferalsBox addSubview:self.perfinChooser.view];
    [self.perfinChooser.view setFrameOrigin:NSMakePoint(7, 5)];
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

- (IBAction)addStamp:(id)sender {
    // Get the quantity input for creating a multi-quantity composite.
    NSInteger compositeQuantity = [self.compositeQuantityInput integerValue];
    
    if (compositeQuantity > 1) {
        if (self.composite != nil) return;
        
        // Create a multi-quantity composite and add it to the collection
        // as one item.
        Stamp * composite = [self.stamp createCompositeFromThisContainingAmount:compositeQuantity];
        [self.collection addStampsObject:composite];
    }
    else {
        if (self.composite == nil) {
            // Add the new stamp to the collection.
            [self.collection addStampsObject:self.stamp];
        }
        else {
            [self.composite addChildrenObject:self.stamp];
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
    
    // Duplicate the stamp for the next possible entry.
    self.stamp = [self.stamp duplicate];
}

@end
