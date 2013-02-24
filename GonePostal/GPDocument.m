//
//  GPDocument.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPDocument.h"
#import "GPCatalogEditor.h"
#import "GPSupportedCountriesController.h"
#import "GPSupportedFormatsController.h"
#import "GPSupportedGroupsController.h"
#import "GPSupportedAltCatalogNamesController.h"
#import "GPSupportedAltCatalogSectionsController.h"
#import "GPCatalogDefaults.h"
#import "GPPlatePositionsController.h"
#import "NSPersistentDocument+FileWrapperSupport.h"
#import "GPFilenameTransformer.h"
#import "GPAlternateCatalogNumberTransformer.h"
#import "GPEmptySetChecker.h"
#import "GPPlateUsageExistsChecker.h"
#import "GPSupportedCachetCatalogsController.h"
#import "GPSupportedCachetMakersController.h"

/*
 Name of the database within the file wrapper.
 */
static NSString *StoreFileName = @"CoreDataStore.sql";

@implementation GPDocument

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize value transformers.
        id pathTransformer = [[GPFilenameTransformer alloc] initWithDocument:self];
        [NSValueTransformer setValueTransformer:pathTransformer forName:@"GPFilenameTransformer"];
        
        id altCatalogNumberTransformer = [[GPAlternateCatalogNumberTransformer alloc] initWithManagedObjectContext:self.managedObjectContext];
        [NSValueTransformer setValueTransformer:altCatalogNumberTransformer forName:@"GPAlternateCatalogNumberTransformer"];
        
        id emptySetChecker = [[GPEmptySetChecker alloc] init];
        [NSValueTransformer setValueTransformer:emptySetChecker forName:@"GPEmptySetChecker"];
        
        
        id plate1Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:1]];
        [NSValueTransformer setValueTransformer:plate1Exists forName:@"Plate1ExistsChecker"];
        id plate2Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:2]];
        [NSValueTransformer setValueTransformer:plate2Exists forName:@"Plate2ExistsChecker"];
        id plate3Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:3]];
        [NSValueTransformer setValueTransformer:plate3Exists forName:@"Plate3ExistsChecker"];
        id plate4Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:4]];
        [NSValueTransformer setValueTransformer:plate4Exists forName:@"Plate4ExistsChecker"];
        id plate5Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:5]];
        [NSValueTransformer setValueTransformer:plate5Exists forName:@"Plate5ExistsChecker"];
        id plate6Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:6]];
        [NSValueTransformer setValueTransformer:plate6Exists forName:@"Plate6ExistsChecker"];
        id plate7Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:7]];
        [NSValueTransformer setValueTransformer:plate7Exists forName:@"Plate7ExistsChecker"];
        id plate8Exists = [[GPPlateUsageExistsChecker alloc] initWithPlateNumberCheck:[NSNumber numberWithUnsignedInt:8]];
        [NSValueTransformer setValueTransformer:plate8Exists forName:@"Plate8ExistsChecker"];
        
    }
    return self;
}

- (NSString *)windowNibName {
    return @"GPDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
}

+ (BOOL)autosavesInPlace
{
    return NO;
}

- (IBAction)openGPCatalogEditor:(id)sender {
    GPCatalogEditor * catalogEditor = [[GPCatalogEditor alloc] initWithWindowNibName:@"GPCatalogEditor"];
    [self addWindowController:catalogEditor];
    [catalogEditor setManagedObjectContext:self.managedObjectContext];
    
    [catalogEditor.window makeKeyAndOrderFront:self];
}

- (void)openGPCatalogDefaults:(id)sender {
    GPCatalogDefaults * gpCatalogDefaultsWindow = [[GPCatalogDefaults alloc] initWithWindowNibName:@"GPCatalogDefaults"];
    [self addWindowController:gpCatalogDefaultsWindow];
    [gpCatalogDefaultsWindow setManagedObjectContext:self.managedObjectContext];
    
    [gpCatalogDefaultsWindow.window makeKeyAndOrderFront:self];
}

- (void)editSupportedCountries:(id)sender {
    GPSupportedCountriesController * supportedCountriesController = [[GPSupportedCountriesController alloc] initWithWindowNibName:@"GPSupportedCountriesController"];
    [self addWindowController:supportedCountriesController];
    [supportedCountriesController setManagedObjectContext:self.managedObjectContext];
    
    [supportedCountriesController.window makeKeyAndOrderFront:self];
}

- (void)editSupportedFormats:(id)sender {
    GPSupportedFormatsController * supportedFormatsController = [[GPSupportedFormatsController alloc] initWithWindowNibName:@"GPSupportedFormatsController"];
    [self addWindowController:supportedFormatsController];
    [supportedFormatsController setManagedObjectContext:self.managedObjectContext];
    
    [supportedFormatsController.window makeKeyAndOrderFront:self];
}

- (void)editSupportedAltCatalogNames:(id)sender {
    GPSupportedAltCatalogNamesController * supportedAltCatalogNamesController = [[GPSupportedAltCatalogNamesController alloc] initWithWindowNibName:@"GPSupportedAltCatalogNamesController"];
    [self addWindowController:supportedAltCatalogNamesController];
    [supportedAltCatalogNamesController setManagedObjectContext:self.managedObjectContext];
    
    [supportedAltCatalogNamesController.window makeKeyAndOrderFront:self];
}

- (void)editSupportedAltCatalogSections:(id)sender {
    GPSupportedAltCatalogSectionsController * supportedAltCatalogSectionsController = [[GPSupportedAltCatalogSectionsController alloc] initWithWindowNibName:@"GPSupportedAltCatalogSectionsController"];
    [self addWindowController:supportedAltCatalogSectionsController];
    [supportedAltCatalogSectionsController setManagedObjectContext:self.managedObjectContext];
    
    [supportedAltCatalogSectionsController.window makeKeyAndOrderFront:self];
}

- (void)editSupportedGroups:(id)sender {
    GPSupportedGroupsController * supportedGroupsController = [[GPSupportedGroupsController alloc] initWithWindowNibName:@"GPSupportedGroupsController"];
    [self addWindowController:supportedGroupsController];
    [supportedGroupsController setManagedObjectContext:self.managedObjectContext];
    
    [supportedGroupsController.window makeKeyAndOrderFront:self];
}

- (void)editSupportedPlatePositions:(id)sender {
    GPPlatePositionsController * controller = [[GPPlatePositionsController alloc] initWithWindowNibName:@"GPPlatePositionsController"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedCachetCatalogs:(id)sender {
    GPSupportedCachetCatalogsController * controller = [[GPSupportedCachetCatalogsController alloc] initWithWindowNibName:@"GPSupportedCachetCatalogsController"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedCachetMakers:(id)sender {
    GPSupportedCachetMakersController * controller = [[GPSupportedCachetMakersController alloc] initWithWindowNibName:@"GPSupportedCachetMakersController"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

/*
 Sets the on-disk location.  NSPersistentDocument's implementation is bypassed using the FileWrapperSupport category.
 configurePersistentStoreCoordinatorForURL is overridden to point NSPersistantDocument into the wrapper.
 */
- (void)setFileURL:(NSURL *)fileURL {
    [self simpleSetFileURL:fileURL];
}

// Configures the store coordinator to use the database file inside the wrapper.
- (BOOL)configurePersistentStoreCoordinatorForURL:(NSURL *)fileURL ofType:(NSString *)fileType modelConfiguration:(NSString *)configuration storeOptions:(NSDictionary *)storeOptions error:(NSError **)outError {
    // Configure the persistant store coordinator to use the store inside the wrapper.
    NSURL * storeURL = [self storeURLFromPath:[[self fileURL] path]];
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    
    NSPersistentStore * store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:configuration URL:storeURL options:storeOptions error:outError];
    
    return (store != nil);
}

/*
 Returns the URL for the wrapped Core Data store file. This appends the StoreFileName to the document's path.
 */
- (NSURL *)storeURLFromPath:(NSString *)filePath {
    filePath = [filePath stringByAppendingPathComponent:StoreFileName];
    if (filePath != nil) {
        return [NSURL fileURLWithPath:filePath];
    }
    return nil;
}

/*
 Overridden NSDocument/NSPersistentDocument method to save documents.
 */
- (BOOL)writeSafelyToURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName forSaveOperation:(NSSaveOperationType)inSaveOperation error:(NSError **)outError {
    BOOL success = YES;
	NSURL *originalURL = [self fileURL];
    
    // Depending on the type of save operation:
    if (inSaveOperation == NSSaveAsOperation) {
        NSFileWrapper *filewrapper = nil;
        NSString *filePath = [inAbsoluteURL path];
        
        // Nothing exists at the URL: set up the directory and migrate the Core Data store.
        filewrapper = [[NSFileWrapper alloc] initDirectoryWithFileWrappers:nil];
        // Need to write once so there's somewhere for the store file to go.
        [filewrapper writeToURL:inAbsoluteURL options:NSFileWrapperWritingAtomic originalContentsURL:nil error:outError];
        
        // Now, the Core Data store...
        NSURL *storeURL = [self storeURLFromPath:filePath];
        NSURL *originalStoreURL = [self storeURLFromPath:[originalURL path]];
		
        NSPersistentStoreCoordinator *coordinator = [[self managedObjectContext] persistentStoreCoordinator];
        
        if (originalStoreURL != nil) {
            // This is a "Save As", so migrate the store to the new URL.
            id originalStore = [coordinator persistentStoreForURL:originalStoreURL];
            success = ([coordinator migratePersistentStore:originalStore toURL:storeURL options:nil withType:[self persistentStoreTypeForFileType:inTypeName] error:outError] != nil);
        }
		else {
            // This is the first Save of a new document, so add new store.
            success = ([coordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:outError] != nil);
        }
        
        [filewrapper addFileWithPath:[storeURL path]];
    }
 
    if (success) {
        // Save the Core Data portion of the document.
        success = [[self managedObjectContext] save:outError];
  
        // Set the appropriate file attributes (such as "Hide File Extension")
        NSDictionary *fileAttributes = [self fileAttributesToWriteToURL:inAbsoluteURL ofType:inTypeName forSaveOperation:inSaveOperation originalContentsURL:originalURL error:outError];
        [[NSFileManager defaultManager] setAttributes:fileAttributes ofItemAtPath:[inAbsoluteURL path] error:outError];
    }
	
    return success;
}

- (BOOL)saveInPlace {
    NSError * error;
    BOOL rc = [self saveToURL:[self fileURL] ofType:[self fileType] forSaveOperation:NSSaveOperation error:&error];
    
    if (rc == NO) {
        NSLog(@"Error saving to %@:  %@, %@", [[self fileURL] path], error, error.userInfo);
    }
    
    return rc;
}

/*
 The revert method needs to completely tear down the object graph assembled by the document. In this case, you also want to remove the persistent store manually, because NSPersistentDocument will expect the store for its coordinator to be located at the document URL (instead of inside that URL as part of the file wrapper).
 */
- (BOOL)revertToContentsOfURL:(NSURL *)inAbsoluteURL ofType:(NSString *)inTypeName error:(NSError **)outError {
    NSPersistentStoreCoordinator *psc = [[self managedObjectContext] persistentStoreCoordinator];
    id store = [psc persistentStoreForURL:[self storeURLFromPath:[inAbsoluteURL path]]];
    if (store) {
        [psc removePersistentStore:store error:outError];
    }
    return [super revertToContentsOfURL:inAbsoluteURL ofType:inTypeName error:outError];
}

- (NSString *)addPictureToWrapper {
    NSString * fileName = nil;
    
    // Get the absoluate URL of the picture from the user.
    NSOpenPanel * picChooser = [NSOpenPanel openPanel];
    [picChooser setCanChooseFiles:YES];
    [picChooser setCanChooseDirectories:NO];
    [picChooser setAllowsMultipleSelection:NO];
    
    NSArray * allowedPicTypes = @[@"jpg", @"png"];
    [picChooser setAllowedFileTypes:allowedPicTypes];
    
    NSInteger rc = [picChooser runModal];
    if (rc != NSFileHandlingPanelOKButton)
        return fileName;
    
    // Get the picture URL from the dialog.
    NSURL * picURL = [[picChooser URLs] objectAtIndex:0];
    
    // Wrap the image file
    NSError * error;
    NSFileWrapper *imageFile = [[NSFileWrapper alloc] initWithURL:picURL options:NSFileWrapperReadingImmediate error:&error];
    if (imageFile == nil) {
        NSLog(@"Error opening image file: %@, %@", error, error.userInfo);
        return fileName;
    }
    
    fileName = picURL.lastPathComponent;
    [imageFile setPreferredFilename:fileName];
    
    NSURL * newPicURL = [[self fileURL] URLByAppendingPathComponent:fileName];
    
    // Move the image file into the GPWrapper
    BOOL writeRC = [imageFile writeToURL:newPicURL options:NSFileWrapperWritingWithNameUpdating originalContentsURL:picURL error:&error];
    if (!writeRC) {
        NSLog(@"Error moving image file into wrapper: %@, %@", error, error.userInfo);
        return fileName;
    }
    
    // Add the picture to the GPWrapper
    NSFileWrapper *fileWrapper = [[NSFileWrapper alloc] initWithPath:[[self fileURL] path]];
    [fileWrapper addFileWrapper:imageFile];
    
    return fileName;
}


@end
