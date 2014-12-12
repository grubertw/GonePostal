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
@property (weak, nonatomic) IBOutlet NSArrayController * allowedStampFormatsController;

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
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        _altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        _altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *subTypesSort = [[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES];
        _subvarietyTypesSortDescriptors = @[subTypesSort];
        
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
    
    // Create the subvariety from the major variety.
    GPCatalog * subvariety = [GPCatalog createFromMajorVariety:self.theMajorVariety];
    [self.gpCatalogEntryController setContent:subvariety];
    
    // Set the default subvariety type.
    NSFetchRequest * subFetch = [NSFetchRequest fetchRequestWithEntityName:@"GPSubvarietyType"];
    NSPredicate * subPred = [NSPredicate predicateWithFormat:@"acronym like %@", @"SUB"];
    [subFetch setPredicate:subPred];
    
    NSArray * subs = [self.managedObjectContext executeFetchRequest:subFetch error:nil];
    if (subs) {
        subvariety.subvarietyType = subs[0];
    }
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Create Subvariety";
}

- (IBAction)addSubvarieties:(id)sender {
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
            [self.theMajorVariety addSubvarietiesObject:dup];
        }
    }
    
    // Track the added GPIDs for display purposes.
    [self.addedGPIDs addObject:entry];
    [self.addedGPIDsController setContent:self.addedGPIDs];
    [self.theMajorVariety addSubvarietiesObject:entry];
    
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
    [self.alternateCatalogsController add:self];
}

- (IBAction)addAllowedStampFormat:(id)sender {
    if (self.allowedStampFormatToAdd == nil) return;
    
    [self.allowedStampFormatsController addObject:self.allowedStampFormatToAdd];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAllowedStampFormat:(id)sender {
    [self.allowedStampFormatsController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
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
            
            [self.theMajorVariety addSubvarietiesObject:dup];
            [self.addedGPIDs addObject:dup];
        }
    }
    
    [self.theMajorVariety addSubvarietiesObject:entry];
    [self.addedGPIDs addObject:entry];
    
    [self.catalogEditor loadSubvarieties:self.theMajorVariety];
    
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
