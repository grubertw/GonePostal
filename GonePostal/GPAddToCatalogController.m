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
#import "GPCatalogAlbumSize.h"

@interface GPAddToCatalogController ()
@property (weak, nonatomic) IBOutlet NSTableView * addedGPIDsTable;
@property (strong, nonatomic) IBOutlet NSArrayController * addedGPIDsController;
@property (weak, nonatomic) IBOutlet NSArrayController * allowedStampFormatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogDateController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogPeopleController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpPlateSizeController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogQuantityController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogAlbumSizeController;
@property (strong, nonatomic) NSMutableArray * addedGPIDs;

@property (weak, nonatomic) IBOutlet NSScrollView * scroller;
@property (strong, nonatomic) IBOutlet NSView * scrollContent;

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
        
        NSSortDescriptor *gpCatalogDateSort = [[NSSortDescriptor alloc] initWithKey:@"dateType.name" ascending:YES];
        _gpCatalogDateSortDescriptors = @[gpCatalogDateSort];
        
        NSSortDescriptor *gpCatalogPeopleSort = [[NSSortDescriptor alloc] initWithKey:@"peopleType.name" ascending:YES];
        _gpCatalogPeopleSortDescriptors = @[gpCatalogPeopleSort];
        
        NSSortDescriptor *gpCatalogPlateSizeSort = [[NSSortDescriptor alloc] initWithKey:@"plateSizeType.name" ascending:YES];
        _gpCatalogPlateSizeSortDescriptors = @[gpCatalogPlateSizeSort];
        
        NSSortDescriptor *gpCatalogQuantitySort = [[NSSortDescriptor alloc] initWithKey:@"quantityType.name" ascending:YES];
        _gpCatalogQuantitySortDescriptors = @[gpCatalogQuantitySort];
        
        NSSortDescriptor *gpCatalogAlbumSizeSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _gpCatalogAlbumSizeSortDescriptors = @[gpCatalogAlbumSizeSort];
        
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.window performClose:self];
        return;
    }

    // Create a new entry from the defaults.
    GPCatalog * entry = [GPCatalog createFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    
    [self.gpCatalogEntryController setContent:entry];
    
    // Initialize the scroller
    [self.scroller setDocumentView:self.scrollContent];
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.scroller documentView] frame]) -
                                    [[self.scroller contentView] bounds].size.height);
    [[self.scroller documentView] scrollPoint:newOrigin];
    
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
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
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext rollback];
        return;
    }
    
    [self.window performClose:self];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:self];
}

- (IBAction)addGPCatalogDate:(id)sender {
    [self.gpCatalogDateController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogDate:(id)sender {
    [self.gpCatalogDateController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPPlateSize:(id)sender {
    [self.gpPlateSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPPlateSize:(id)sender {
    [self.gpPlateSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)createAlbumSizesFromAvailableFormats:(id)sender {
    GPCatalog * entry = self.gpCatalogEntryController.content;
    NSSet * availableFormats = [entry allowedStampFormats];
    
    for (StampFormat * format in availableFormats) {
        GPCatalogAlbumSize * albumSize = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogAlbumSize" inManagedObjectContext:self.managedObjectContext];
        albumSize.format = format;
        
        [entry addAlbumSizesObject:albumSize];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
        return;
    }
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
