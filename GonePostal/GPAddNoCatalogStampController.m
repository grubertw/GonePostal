//
//  GPAddNoCatalogStampController.m
//  GonePostal
//
//  Created by Travis Gruber on 12/12/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPAddNoCatalogStampController.h"
#import "GPDocument.h"
#import "Stamp+Create.h"
#import "Stamp+Duplicate.h"

@interface GPAddNoCatalogStampController ()
@property (strong, nonatomic) GPCollection * collection;

@property (weak, nonatomic) IBOutlet NSTextField * quantityInput;
@property (weak, nonatomic) IBOutlet NSObjectController * stampController;

@property bool savePressed;
@end

@implementation GPAddNoCatalogStampController

- (id)initWithCollection:(GPCollection *)stampCollection {
    self = [super initWithWindowNibName:@"GPAddNoCatalogStampController"];
    if (self) {
        _savePressed = false;
        
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
        
        _collection = stampCollection;
        _managedObjectContext = [stampCollection managedObjectContext];
    }
    
    return self;
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Save any uncommited changes before beginning.
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.window performClose:self];
        return;
    }
    
    // Create the new stamp.
    Stamp * newStamp = [Stamp CreateFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    [self.stampController setContent:newStamp];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Create Uncatalogged Stamp Entry";
}

- (IBAction)addUncataloggedStamp:(id)sender {
    Stamp * stamp = [self.stampController content];
    stamp.manual_value_overrides_catalog_value = @(YES);
    [self.collection addStampsObject:stamp];
    
    NSInteger count = [self.quantityInput integerValue];
    
    if (count > 1) {
        count--;
        
        for (NSInteger i=0; i<count; i++) {
            // Duplicate the stamp within the model controller
            Stamp * dup = [stamp duplicate];
            [self.collection addStampsObject:dup];
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
    
    // Prepaire the next entry.
    Stamp * nextStamp = [stamp duplicate];
    [self.stampController setContent:nextStamp];
}

- (IBAction)save:(id)sender {
    self.savePressed = YES;
    
    Stamp * stamp = [self.stampController content];
    stamp.manual_value_overrides_catalog_value = @(YES);
    [self.collection addStampsObject:stamp];
    
    NSInteger count = [self.quantityInput integerValue];
    
    if (count > 1) {
        count--;
        
        for (NSInteger i=0; i<count; i++) {
            // Duplicate the stamp within the model controller
            Stamp * dup = [stamp duplicate];
            [self.collection addStampsObject:dup];
        }
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
    
    [self.window performClose:self];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:self];
}

- (IBAction)addDefaultPicture:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"default_picture" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    stamp.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_1" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_2" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_3" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_4" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_5" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    // Store the filename into the model.
    Stamp * stamp = [self.stampController content];
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:stamp.gp_stamp_number forAttribute:@"alternate_picture_6" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    stamp.alternate_picture_6 = fileName;
}

- (void)windowWillClose:(NSNotification *)notification {
    if (!self.savePressed) {
        // Rollback all changed to the managed object context
        // that have not been explicitly saved.
        [self.managedObjectContext rollback];
    }
}

@end
