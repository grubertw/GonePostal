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
#import "GPMultipleSelectionChecker.h"
#import "GPPlateUsageExistsChecker.h"
#import "GPSupportedCachetCatalogsController.h"
#import "GPSupportedCachetMakersController.h"
#import "GPSearchSelectionTransformer.h"
#import "StoredSearch.h"
#import "GPStampViewer.h"
#import "GPSupportedCancelQuality.h"
#import "GPSupportedCentering.h"
#import "GPSupportedDealers.h"
#import "GPSupportedStampFormats.h"
#import "GPSupportedGrades.h"
#import "GPSupportedGumConditions.h"
#import "GPSupportedHinged.h"
#import "GPSupportedLocations.h"
#import "GPSupportedLots.h"
#import "GPSupportedMounts.h"
#import "GPSupportedSoundness.h"
#import "GPSupportedLocalPrecancels.h"
#import "GPSupportedPerfins.h"
#import "GPSupportedPerfinCatalogs.h"

// static indexes into the CustomSearches table for fetching data.
const NSInteger ASSISTED_GP_CATALOG_EDITER_SEARCH_ID = 1;
const NSInteger ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID = 2;
const NSInteger ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID = 3;

NSString * BASE_GP_CATALOG_QUERY = @"is_default==0 and majorVariety==nil";
NSString * BASE_GP_CATALOG_QUERY_WITH_SUBVARIETIES = @"is_default==0";

/*
 Name of the database within the file wrapper.
 */
static NSString *StoreFileName = @"CoreDataStore.sql";

// Private members and functions.
@interface GPDocument()

@end

@implementation GPDocument

// Parses through the stored search predicate, breaking it down into
// it's component pieces.  Further parsing of the subbredicate is done
// later in the individual window search controllers.
- (void)parseAssistedSearch:(NSPredicate *)search parent:(NSPredicate *)parentSearch {
    if ([search isMemberOfClass:[NSCompoundPredicate class]]) {
        // Break the compound predicate into it's component pieces.
        NSArray * subpreds = ((NSCompoundPredicate *)search).subpredicates;
        
        //NSLog(@"parseAssistedSearch found %ld subpredicates in compound predicate", subpreds.count);
        
        for (NSPredicate * subPredicate in subpreds) {
            // Recursivly call into this method to determine the comparison type.
            [self parseAssistedSearch:subPredicate parent:search];
        }
    }
    else if ([search isMemberOfClass:[NSComparisonPredicate class]]) {
        // Obtain the left expression to determine which of
        // the three preicate types this is.
        NSExpression * leftExpression = ((NSComparisonPredicate *)search).leftExpression;
        
        //NSLog(@"parseAssistedSearch found comparison predicate with leftExpression of type %ld", leftExpression.expressionType);
        
        if (leftExpression.expressionType == NSKeyPathExpressionType) {
            // Determine if the respresenting predicate needs to be this predicate
            // or the parent.
            NSPredicate * representingPredicate;
            if (   parentSearch == nil
                || [parentSearch isEqualTo:self.assistedSearch.predicate])
                representingPredicate = search;
            else
                representingPredicate = parentSearch;
            
            //NSLog(@"  leftExpression keyPath is %@", leftExpression.keyPath);
            
            if (   [leftExpression.keyPath isEqualToString:@"country.country_sort_id"]
                || [leftExpression.keyPath isEqualToString:@"gpCatalog.country.country_sort_id"]) {
                self.countriesPredicate = representingPredicate;
            }
            else if (   [leftExpression.keyPath isEqualToString:@"catalogGroup.group_number"]
                     || [leftExpression.keyPath isEqualToString:@"gpCatalog.catalogGroup.group_number"]) {
                self.sectionsPredicate = representingPredicate;
            }
            else if ([leftExpression.keyPath isEqualToString:@"format.name"]) {
                self.formatsPredicate = representingPredicate;
            }
            else if ([leftExpression.keyPath isEqualToString:@"location.name"]) {
                self.locationsPredicate = representingPredicate;
            }
            else if (   ![leftExpression.keyPath isEqualToString:@"is_default"]
                     && ![leftExpression.keyPath isEqualToString:@"majorVariety"]) {
                self.filtersPredicate = representingPredicate;
            }
        }
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialize sort descriptors
        NSSortDescriptor *gpCollectionSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.gpCollectionSortDescriptors = @[gpCollectionSort];
        
        // Initialize value transformers.
        id pathTransformer = [[GPFilenameTransformer alloc] initWithDocument:self];
        [NSValueTransformer setValueTransformer:pathTransformer forName:@"GPFilenameTransformer"];
        
        id altCatalogNumberTransformer = [[GPAlternateCatalogNumberTransformer alloc] initWithManagedObjectContext:self.managedObjectContext];
        [NSValueTransformer setValueTransformer:altCatalogNumberTransformer forName:@"GPAlternateCatalogNumberTransformer"];
        
        id searchSelectionTransformer = [[GPSearchSelectionTransformer alloc] init];
        [NSValueTransformer setValueTransformer:searchSelectionTransformer forName:@"GPSearchSelectionTransformer"];
        
        id emptySetChecker = [[GPEmptySetChecker alloc] init];
        [NSValueTransformer setValueTransformer:emptySetChecker forName:@"GPEmptySetChecker"];
        
        id multiSelChecker = [[GPMultipleSelectionChecker alloc] init];
        [NSValueTransformer setValueTransformer:multiSelChecker forName:@"GPMultipleSelectionChecker"];
        
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

- (void)loadAssistedSearch:(NSInteger)searchID {
    self.countriesPredicate = nil;
    self.sectionsPredicate = nil;
    self.filtersPredicate = nil;
    self.formatsPredicate = nil;
    self.locationsPredicate = nil;
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"identifier==%ld", searchID];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Fetch error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    if (results.count == 1) {
        self.assistedSearch = [results objectAtIndex:0];
        
        // Parse the assisted search into it's component predicates.
        [self parseAssistedSearch:self.assistedSearch.predicate parent:nil];
    }
    else {
        if (   searchID == ASSISTED_GP_CATALOG_EDITER_SEARCH_ID
            || searchID == ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID) {
            // Create the query from the factory default.
            self.assistedSearch = [NSEntityDescription insertNewObjectForEntityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
            self.assistedSearch.predicate = [NSPredicate predicateWithFormat:BASE_GP_CATALOG_QUERY];
        }
        else if (searchID == ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID) {
            // Leave predicate empty until user enters a search.
            self.assistedSearch = [NSEntityDescription insertNewObjectForEntityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
        }
        
        self.assistedSearch.identifier = [NSNumber numberWithInt:searchID];
    }
}

- (IBAction)addGPCollection:(id)sender {
    [self.gpCollectionController insert:sender];
}

- (IBAction)openGPCatalogEditor:(id)sender {
    // initialize and load the GPCatalog editor's assisted search.
    [self loadAssistedSearch:ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
    
    GPCatalogEditor * catalogEditor = [[GPCatalogEditor alloc] initWithAssistedSearch:self.assistedSearch countrySearch:self.countriesPredicate sectionSearch:self.sectionsPredicate filterSearch:self.filtersPredicate];
    
    [self addWindowController:catalogEditor];
    [catalogEditor.window makeKeyAndOrderFront:self];
}

- (IBAction)openUserGuide:(id)sender {
    
}

- (IBAction)openReports:(id)sender {
    
}

- (IBAction)openImportExport:(id)sender {
    
}

- (IBAction)viewStamps:(id)sender {
    // Get the row of the viewStamp button clicked
    NSInteger row = [self.gpCollectionTable rowForView:sender];
    GPCollection * stampCollection = self.gpCollectionController.arrangedObjects[row];
    
    [self loadAssistedSearch:ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID];
    GPStampViewer * stampViewer = [[GPStampViewer alloc] initWithCollection:stampCollection assistedSearch:self.assistedSearch countrySearch:self.countriesPredicate sectionSearch:self.sectionsPredicate formatSearch:self.formatsPredicate locationSearch:self.locationsPredicate];
    
    [self addWindowController:stampViewer];
    [stampViewer.window makeKeyAndOrderFront:self];
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

- (void)editSupportedCancelQuality:(id)sender {
    GPSupportedCancelQuality * controller = [[GPSupportedCancelQuality alloc] initWithWindowNibName:@"GPSupportedCancelQuality"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedCentering:(id)sender {
    GPSupportedCentering * controller = [[GPSupportedCentering alloc] initWithWindowNibName:@"GPSupportedCentering"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedDealers:(id)sender {
    GPSupportedDealers * controller = [[GPSupportedDealers alloc] initWithWindowNibName:@"GPSupportedDealers"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedStampFormats:(id)sender {
    GPSupportedStampFormats * controller = [[GPSupportedStampFormats alloc] initWithWindowNibName:@"GPSupportedStampFormats"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedGrades:(id)sender {
    GPSupportedGrades * controller = [[GPSupportedGrades alloc] initWithWindowNibName:@"GPSupportedGrades"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedGumConditions:(id)sender {
    GPSupportedGumConditions * controller = [[GPSupportedGumConditions alloc] initWithWindowNibName:@"GPSupportedGumConditions"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedHinged:(id)sender {
    GPSupportedHinged * controller = [[GPSupportedHinged alloc] initWithWindowNibName:@"GPSupportedHinged"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedLocations:(id)sender {
    GPSupportedLocations * controller = [[GPSupportedLocations alloc] initWithWindowNibName:@"GPSupportedLocations"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedLots:(id)sender {
    GPSupportedLots * controller = [[GPSupportedLots alloc] initWithWindowNibName:@"GPSupportedLots"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedMounts:(id)sender {
    GPSupportedMounts * controller = [[GPSupportedMounts alloc] initWithWindowNibName:@"GPSupportedMounts"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedSoundness:(id)sender {
    GPSupportedSoundness * controller = [[GPSupportedSoundness alloc] initWithWindowNibName:@"GPSupportedSoundness"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedLocalPrecancels:(id)sender {
    GPSupportedLocalPrecancels * controller = [[GPSupportedLocalPrecancels alloc] initWithWindowNibName:@"GPSupportedLocalPrecancels"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedPerfins:(id)sender {
    GPSupportedPerfins * controller = [[GPSupportedPerfins alloc] initWithWindowNibName:@"GPSupportedPerfins"];
    [self addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (void)editSupportedPerfinCatalogs:(id)sender {
    GPSupportedPerfinCatalogs * controller = [[GPSupportedPerfinCatalogs alloc] initWithWindowNibName:@"GPSupportedPerfinCatalogs"];
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
