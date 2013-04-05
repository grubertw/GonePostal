//
//  GPAddSubvariety.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/10/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAddSubvariety.h"
#import "GPDocument.h"
#import "GPCatalog+Create.h"
#import "GPCatalog+Duplicate.h"

@interface GPAddSubvariety ()
@property (strong, nonatomic) IBOutlet NSArrayController * alternateCatalogsController;

@property (weak, nonatomic) IBOutlet NSTableView * addedGPIDsTable;
@property (strong, nonatomic) IBOutlet NSArrayController * addedGPIDsController;
@property (strong, nonatomic) NSMutableArray * addedGPIDs;

@property bool savePressed;

@end

@implementation GPAddSubvariety

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _savePressed = false;
        
        NSSortDescriptor *gpCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:NO];
        _gpCatalogSortDescriptors = @[gpCatalogSort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        _formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        _altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        _altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        _addedGPIDs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Save any uncommited changes before beginning.
    [self.document saveInPlace];
    
    // Create the subvariety from the major variety.
    GPCatalog * subvariety = [GPCatalog createFromMajorVariety:self.theMajorVariety];
    [self.gpCatalogEntryController setContent:subvariety];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Create Subvariety";
}

- (IBAction)addSubvarieties:(id)sender {
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the GPCatalog entry inserted from the model controller.
        for (NSInteger i=0; i<count; i++) {
            [self.addedGPIDs addObject:entry];
            GPCatalog * dup = [entry duplicateFromThis];
            [self.theMajorVariety addSubvarietiesObject:dup];
        }
    }
    
    // Track the added GPIDs for display purposes.
    [self.addedGPIDs addObject:entry];
    [self.addedGPIDsController setContent:self.addedGPIDs];
    
    // Save the managed object context
    [self.document saveInPlace];
    
    // Prepare for the next entry.
    GPCatalog * nextEntry = [entry duplicateFromThis];
    [self.theMajorVariety addSubvarietiesObject:nextEntry];
    
    [self.gpCatalogEntryController setContent:nextEntry];
}

- (IBAction)addAlternateCatalogEntry:(id)sender {
    [self.alternateCatalogsController add:self];
}

- (IBAction)save:(id)sender {
    self.savePressed = true;
    
    // Insert the GPCatalog entry in the controller to the
    // managed object context.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the GPCatalog entry inserted from the model controller.
        for (NSInteger i=0; i<count; i++) {
            GPCatalog * dup = [entry duplicateFromThis];
            [self.theMajorVariety addSubvarietiesObject:dup];
        }
    }
    
    // Save the managed object context and close the window.
    [self.document saveInPlace];
    
    // Reload the catalog editor's content
    if (self.catalogEditor.subvarietiesActive)
        [self.catalogEditor querySubvarieties];
    else
        [self.catalogEditor queryGPCatalog];
    
    [self.window performClose:self];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:self];
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    entry.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    entry.alternate_picture_6 = fileName;
}

- (void)windowWillClose:(NSNotification *)notification {
    if (!self.savePressed) {
        // Rollback all changed to the managed object context
        // that have not been explicitly saved.
        [self.managedObjectContext rollback];
    }
}

@end
