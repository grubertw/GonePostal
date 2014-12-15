//
//  GPAddToCatalogController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAddToCatalogController.h"
#import "GPDocument.h"
#import "GPCatalog+Create.h"
#import "GPCatalog+Duplicate.h"

@interface GPAddToCatalogController ()
@property (weak, nonatomic) IBOutlet NSTableView * addedGPIDsTable;
@property (strong, nonatomic) IBOutlet NSArrayController * addedGPIDsController;
@property (weak, nonatomic) IBOutlet NSArrayController * allowedStampFormatsController;
@property (strong, nonatomic) NSMutableArray * addedGPIDs;

@property bool savePressed;
@end

@implementation GPAddToCatalogController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _savePressed = false;
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        _countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        _altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        _gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        _altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *gpCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:NO];
        _gpCatalogSortDescriptors = @[gpCatalogSort];
        
        _addedGPIDs = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Save any uncommited changes before beginning.
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.window performClose:self];
        return;
    }

    // Create a new entry from the defaults.
    GPCatalog * entry = [GPCatalog createFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    
    [self.gpCatalogEntryController setContent:entry];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Add to GP Catalog";
}

- (IBAction)addGPCatalogEntries:(id)sender {
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    // Get the incrmenting and non-incrmenting part of the GPID.
    NSString * staticID = [GPDocument parseStaticID:entry.gp_catalog_number];
    NSInteger startingID = [GPDocument parseStartingID:entry.gp_catalog_number];
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the GPCatalog entry inserted from the model controller.
        for (NSInteger i=0; i<count; i++) {
            GPCatalog * dup = [entry duplicateFromThis];
            
            // Increment and assign the GPID.
            startingID += GPID_INCREMENT;
            dup.gp_catalog_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
            
            [self.addedGPIDs addObject:dup];
        }
    }
    
    // Track the added GPIDs for display purposes.
    [self.addedGPIDs addObject:entry];
    [self.addedGPIDsController setContent:self.addedGPIDs];

    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
    
    // Prepare for the next entry.
    GPCatalog * nextEntry = [entry duplicateFromThis];
    
    // Increment and assign the GPID.
    startingID += GPID_INCREMENT;
    nextEntry.gp_catalog_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
    
    [self.gpCatalogEntryController setContent:nextEntry];
}

- (IBAction)addAlternateCatalogEntry:(id)sender {
    [self.altCatalogsController add:self];
}

- (IBAction)addAllowedStampFormat:(id)sender {
    if (self.allowedStampFormatToAdd == nil) return;
    
    [self.allowedStampFormatsController addObject:self.allowedStampFormatToAdd];
}

- (IBAction)removeAllowedStampFormat:(id)sender {
    [self.allowedStampFormatsController remove:self];
}

- (IBAction)save:(id)sender {
    self.savePressed = true;
    
    // Insert the GPCatalog entry in the controller to the
    // managed object context.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    // Get the incrmenting and non-incrmenting part of the GPID.
    NSString * staticID = [GPDocument parseStaticID:entry.gp_catalog_number];
    NSInteger startingID = [GPDocument parseStartingID:entry.gp_catalog_number];
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the GPCatalog entry inserted from the model controller.
        for (NSInteger i=0; i<count; i++) {
            GPCatalog * dup = [entry duplicateFromThis];
            
            // Increment and assign the GPID.
            startingID += GPID_INCREMENT;
            dup.gp_catalog_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
            
            [self.addedGPIDs addObject:dup];
        }
    }
    
    [self.addedGPIDs addObject:entry];
    [self.catalogEditor.gpCatalogEntriesController addObjects:self.addedGPIDs];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
        return;
    }
    
    [self.window performClose:self];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:self];
}

- (IBAction)addDefaultPicture:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"default_picture" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.default_picture = fileName;
}

- (IBAction)addAlternatePicture1:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_1" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_2" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_3" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_4" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_5" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    entry.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    // Store the filename into the model.
    GPCatalog * entry = self.gpCatalogEntryController.content;
    
    NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_catalog_number forAttribute:@"alternate_picture_6" fileType:GPImportFileTypePicture];
    if (fileName == nil) return;
    
    // Store the filename into the model.
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
