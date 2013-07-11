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
#import "GPCatalog.h"
#import "Format.h"

@interface GPNewStampPage ()
@property (strong, nonatomic) GPDocument * doc;
@property (strong, nonatomic) GPCollection * collection;

@property (strong, nonatomic) IBOutlet NSObjectController * stampController;
@property (strong, nonatomic) IBOutlet NSArrayController * formatController;

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
            
        // Intialize the chooser views.
        _plateNumberChooser = [[GPPlateNumberChooser alloc] initAsDrawer:NO modifyingStamp:nil];
        _cachetChooser = [[GPCachetChooser alloc] initAsDrawer:NO modifyingStamp:nil];
        _bureauPrecancelChooser = [[GPBureauPrecancelChooser alloc] initAsDrawer:NO modifyingStamp:nil];
        _localPrecancelChooser = [[GPLocalPrecancelChooser alloc] initAsDrawer:NO modifyingStamp:nil];
        _perfinChooser = [[GPPerfinChooser alloc] initAsDrawer:NO modifyingStamp:nil];
    }
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Create the initial stamp from the defaults.
    Stamp * stamp = [Stamp CreateFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    [self.stampController setContent:stamp];
    
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
    // (used to show and hide boxes)
    [self addStampObservers];
    
    self.cachetFrame = [self.cachetBox frame];
    self.platesFrame = [self.platesBox frame];
    self.bureauPrecancelFrame = [self.bureauPrecancelBox frame];
    self.localPrecancelFrame = [self.localPrecancelBox frame];
    self.perfinFrame = [self.perfinBox frame];
    self.conditionFrame = [self.usedConditionBox frame];
    self.historyAndStorageFrame = [self.historyAndStorageBox frame];
    self.picturesFrame = [self.picturesBox frame];
    self.notesFrame = [self.notesBox frame];
    
    NSFetchRequest *stampFormatsFetch = [NSFetchRequest fetchRequestWithEntityName:@"StampFormat"];
    NSArray *stampFormats = [self.managedObjectContext executeFetchRequest:stampFormatsFetch error:nil];
    [self.formatController setContent:stampFormats];
}

- (void)setSelectedGPCatalog:(GPCatalog *)gpCatalog {
    _selectedGPCatalog = gpCatalog;
    
    [self.plateNumberChooser setGpCatalog:gpCatalog];
    [self.cachetChooser setSelectedGPCatalog:gpCatalog];
    [self.bureauPrecancelChooser setSelectedGPCatalog:gpCatalog];
    
    Stamp * stamp = [self.stampController content];
    [stamp setGpCatalog:gpCatalog];
    
    // Copy the GPID from the catalog into the stamp.
    [stamp setGp_stamp_number:gpCatalog.gp_catalog_number];
    
    [self.formatController setContent:gpCatalog.formatType.allowedStampFormats];
}

- (void)addStampObservers {
    [self.stampController.content addObserver:self forKeyPath:@"format" options:NSKeyValueObservingOptionNew context:nil];
    [self.stampController.content addObserver:self forKeyPath:@"mint_used" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeStampObservers {
    [self.stampController.content removeObserver:self forKeyPath:@"format"];
    [self.stampController.content removeObserver:self forKeyPath:@"mint_used"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    if ([object isMemberOfClass:[Stamp class]]) {
        [self updateDynamicStampBoxes];
    }
}

- (void)updateDynamicStampBoxes {
    Stamp * stamp = [self.stampController content];
    
    CGFloat top = self.cachetFrame.origin.y + self.cachetFrame.size.height;
    CGFloat currY = top;
    
    if ([stamp.format.displayCachetInfo isEqualToNumber:@(YES)]) {
        [self.cachetBox setFrame:self.cachetFrame];
        currY -= self.cachetFrame.size.height;
    }
    else {
        [self.cachetBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if ([stamp.format.displayPlateInfo isEqualToNumber:@(YES)]) {
        currY -= self.platesFrame.size.height;
        [self.platesBox setFrame:NSMakeRect(self.platesFrame.origin.x,
                                            currY,
                                            self.platesFrame.size.width,
                                            self.platesFrame.size.height)];
    }
    else {
        [self.platesBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if ([stamp.format.displayBureauPrecancelInfo isEqualToNumber:@(YES)]) {
        currY -= self.bureauPrecancelFrame.size.height;
        [self.bureauPrecancelBox setFrame:NSMakeRect(self.bureauPrecancelFrame.origin.x,
                                            currY,
                                            self.bureauPrecancelFrame.size.width,
                                            self.bureauPrecancelFrame.size.height)];
    }
    else {
        [self.bureauPrecancelBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if ([stamp.format.displayLocalPrecancelInfo isEqualToNumber:@(YES)]) {
        currY -= self.localPrecancelFrame.size.height;
        [self.localPrecancelBox setFrame:NSMakeRect(self.localPrecancelFrame.origin.x,
                                            currY,
                                            self.localPrecancelFrame.size.width,
                                            self.localPrecancelFrame.size.height)];
    }
    else {
        [self.localPrecancelBox setFrame:NSMakeRect(0, 0, 0, 0)];
    }
    
    if ([stamp.format.displayPerfinInfo isEqualToNumber:@(YES)]) {
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
    [self.plateNumberChooser setStamp:self.stampController.content];
    
    [self.stampPeriferalsBox addSubview:self.plateNumberChooser.view];
    [self.plateNumberChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseBureauPrecancel:(id)sender {
    if ([self.bureauPrecancelChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    [self.bureauPrecancelChooser setStamp:self.stampController.content];
    
    [self.stampPeriferalsBox addSubview:self.bureauPrecancelChooser.view];
    [self.bureauPrecancelChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseCachet:(id)sender {
    if ([self.cachetChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    [self.cachetChooser setStamp:self.stampController.content];
    
    [self.stampPeriferalsBox addSubview:self.cachetChooser.view];
    [self.cachetChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)chooseLocalPrecancel:(id)sender {
    if ([self.localPrecancelChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    [self.localPrecancelChooser setStamp:self.stampController.content];
    
    [self.stampPeriferalsBox addSubview:self.localPrecancelChooser.view];
    [self.localPrecancelChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)choosePerfin:(id)sender {
    if ([self.perfinChooser.view isDescendantOf:self.stampPeriferalsBox]) return;
    [self.perfinChooser setStamp:self.stampController.content];
    
    [self.stampPeriferalsBox addSubview:self.perfinChooser.view];
    [self.perfinChooser.view setFrameOrigin:NSMakePoint(7, 5)];
}

- (IBAction)addDefaultPicture:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.default_picture" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_1" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_2" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_3" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_4" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_5" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    Stamp * stamp = [self.stampController content];
    NSString * fileName = [self.doc addFileToWrapperUsingGPID:stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_6" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_6 = fileName;
}

- (Stamp *)getCurrentStamp {
    return [self.stampController content];
}

- (IBAction)addAnotherStamp:(id)sender {
    [self addCurrentStamp];
    
    // Remove the observers from the stamp going into the collection.
    [self removeStampObservers];
    
    // Duplicate the stamp for the next possible entry.
    Stamp * stamp = [self.stampController content];
    Stamp * newStamp = [stamp duplicate];
    [self.stampController setContent:newStamp];
    
    // Add the observers to the new stamp.
    [self addStampObservers];
}

// Adds the stamp currently loaded into the page into the collection.
- (void)addCurrentStamp {
    // Get the quantity input for creating a multi-quantity composite.
    NSInteger compositeQuantity = [self.compositeQuantityInput integerValue];
    Stamp * stamp = [self.stampController content];
    
    if (compositeQuantity > 1) {
        if (self.composite != nil) return;
        
        // Create a multi-quantity composite and add it to the collection
        // as one item.
        Stamp * composite = [stamp createCompositeFromThisContainingAmount:compositeQuantity];
        [self.collection addStampsObject:composite];
    }
    else {
        if (self.composite == nil) {
            // Add the new stamp to the collection.
            [self.collection addStampsObject:stamp];
        }
        else {
            [self.composite addChildrenObject:stamp];
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
}

- (void)cleanup {
    [self removeStampObservers];
}

@end
