//
//  GPNewStampPage.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPNewStampPage.h"
#import "GPDocument.h"
#import "Stamp.h"
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

@interface GPNewStampPage ()
@property (strong, nonatomic) GPDocument * doc;

@property (weak, nonatomic) IBOutlet NSScrollView * scroller;
@property (strong, nonatomic) IBOutlet NSView * scrollContent;
@property (weak, nonatomic) IBOutlet NSTextField *plateInfoField;

@property (strong, nonatomic) GPPlateNumberChooser * plateNumberChooser;
@property (strong, nonatomic) GPCachetChooser * cachetChooser;
@property (strong, nonatomic) GPBureauPrecancelChooser * bureauPrecancelChooser;
@property (strong, nonatomic) GPLocalPrecancelChooser * localPrecancelChooser;
@property (strong, nonatomic) GPPerfinChooser * perfinChooser;

@end

@implementation GPNewStampPage

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
        
        // Create the stamp
        if (self.stamp == nil)
            self.stamp = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:self.managedObjectContext];
        
        // Intialize the chooser panels.
        _plateNumberChooser = [[GPPlateNumberChooser alloc] initAsSheet:YES modifyingStamp:self.stamp];
        _cachetChooser = [[GPCachetChooser alloc] initAsSheet:YES modifyingStamp:self.stamp];
        _bureauPrecancelChooser = [[GPBureauPrecancelChooser alloc] initAsSheet:YES modifyingStamp:self.stamp];
        _localPrecancelChooser = [[GPLocalPrecancelChooser alloc] initAsSheet:YES modifyingStamp:self.stamp];
        _perfinChooser = [[GPPerfinChooser alloc] initAsSheet:YES modifyingStamp:self.stamp];
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Initialize the scroller
    [self.scroller setDocumentView:self.scrollContent];
    
    // Set the scroller to the top.
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.scroller documentView] frame]) -
                                    [[self.scroller contentView] bounds].size.height);
    [[self.scroller documentView] scrollPoint:newOrigin];
    
    // Place the Chooser views into panels which will be launched as sheets.
    self.plateNumberChooser.panel = [[NSPanel alloc] initWithContentRect:self.plateNumberChooser.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.plateNumberChooser.panel setContentView:self.plateNumberChooser.view];
    [self.plateNumberChooser setPlateInfoField:self.plateInfoField];
    
    self.cachetChooser.panel = [[NSPanel alloc] initWithContentRect:self.cachetChooser.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.cachetChooser.panel setContentView:self.cachetChooser.view];
    
    self.bureauPrecancelChooser.panel = [[NSPanel alloc] initWithContentRect:self.bureauPrecancelChooser.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.bureauPrecancelChooser.panel setContentView:self.bureauPrecancelChooser.view];
    
    self.localPrecancelChooser.panel = [[NSPanel alloc] initWithContentRect:self.localPrecancelChooser.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.localPrecancelChooser.panel setContentView:self.localPrecancelChooser.view];
    
    self.perfinChooser.panel = [[NSPanel alloc] initWithContentRect:self.perfinChooser.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.perfinChooser.panel setContentView:self.perfinChooser.view];
}

- (void)setSelectedGPCatalog:(GPCatalog *)gpCatalog {
    _selectedGPCatalog = gpCatalog;
    
    [self.plateNumberChooser setGpCatalog:gpCatalog];
    [self.cachetChooser setSelectedGPCatalog:gpCatalog];
    [self.bureauPrecancelChooser setSelectedGPCatalog:gpCatalog];
    
    [self.stamp setGpCatalog:gpCatalog];
}

- (IBAction)addPlate:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.plateNumberChooser.view.window modalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)chooseBureauPrecancel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.bureauPrecancelChooser.view.window modalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)chooseCachet:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.cachetChooser.view.window modalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)chooseLocalPrecancel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.localPrecancelChooser.view.window modalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)choosePerfin:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.perfinChooser.view.window modalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.default_picture"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_1"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_2"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_3"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_4"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_5"];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.doc addPictureToWrapperUsingGPID:self.stamp.gpCatalog.gp_catalog_number forAttribute:@"stamp.alternate_picture_6"];;
    if (fileName == nil) return;
    
    // Store the filename into the model.
    self.stamp.alternate_picture_6 = fileName;
}

@end
