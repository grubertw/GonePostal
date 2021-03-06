//
//  GPAddBureauPrecancel.m
//  GonePostal
//
//  Created by Travis Gruber on 4/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAddBureauPrecancel.h"
#import "BureauPrecancel+Duplicate.h"
#import "GonePostal-Swift.h"

@interface GPAddBureauPrecancel ()

@property (strong, nonatomic) IBOutlet NSArrayController * addedPrecancelsController;

@property (nonatomic) BOOL savePressed;
@end

@implementation GPAddBureauPrecancel

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog {
    self = [super initWithWindowNibName:@"GPAddBureauPrecancel"];
    if (self) {
        _gpCatalog = gpCatalog;
        _managedObjectContext = gpCatalog.managedObjectContext;
        
        NSSortDescriptor *precancelSort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:NO];
        _precancelsSortDescriptors = @[precancelSort];
        
        _currPrecancel = [NSEntityDescription insertNewObjectForEntityForName:@"BureauPrecancel" inManagedObjectContext:_managedObjectContext];
        
        _currPrecancel.gp_precancel_number = gpCatalog.gp_catalog_number;
        
        _addedPrecancels = [[NSMutableArray alloc] initWithCapacity:4];
        _savePressed = NO;
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.window performClose:self];
    }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Create Bureau Precancel";
}

- (IBAction)addPictureToPrecancel:(NSButton *)sender {
    NSString * fileName = [self.document addImageToWrapperUsingGPID:self.currPrecancel.gp_precancel_number forAttribute:@"BureauPrecenacel.picture"];
    if (fileName == nil) return;
    
    [self.currPrecancel setPicture:fileName];
}

- (IBAction)addBureauPrecancel:(id)sender {
    // Add to the list of displayed additions.
    [self.addedPrecancels addObject:self.currPrecancel];
    [self.addedPrecancelsController setContent:self.addedPrecancels];
    
    // Add to catalog.
    [self.gpCatalog addBureauPrecancelsObject:self.currPrecancel];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
    
    // Duplicate a new precancel
    BureauPrecancel * nextPrecancel = [self.currPrecancel duplicate];
    self.currPrecancel = nextPrecancel;
}

- (IBAction)save:(id)sender {
    self.savePressed = YES;
    
    // Add to catalog.
    [self.gpCatalog addBureauPrecancelsObject:self.currPrecancel];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
    
    [self.window performClose:sender];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:sender];
}

- (void)windowWillClose:(NSNotification *)notification {
    if (!self.savePressed) {
        // Rollback all changed to the managed object context
        // that have not been explicitly saved.
        [self.managedObjectContext rollback];
    }
}

@end
