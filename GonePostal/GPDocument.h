//
//  GPDocument.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StoredSearch.h"

// static indexes into the CustomSearches table for fetching data.
extern const NSInteger ASSISTED_GP_CATALOG_EDITER_SEARCH_ID;
extern const NSInteger ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID;
extern const NSInteger ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID;

extern NSString * BASE_GP_CATALOG_QUERY;
extern NSString * BASE_GP_CATALOG_QUERY_WITH_SUBVARIETIES;

//
// Primay class of GonePostal
//
@interface GPDocument : NSPersistentDocument <NSTableViewDelegate>

@property (strong, nonatomic) NSArray * gpCollectionSortDescriptors;

/**
 * Load an assisted search from the StroredSearches database into
 * the referance ojbects listed below.  This method is called from
 * the various editors and viewers when they load.
 *
 * NOTE: The members below are overwritten on each call to this method.
 */
- (void)loadAssistedSearch:(NSInteger)searchID;
@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * filtersPredicate;
@property (strong, nonatomic) NSPredicate * formatsPredicate;
@property (strong, nonatomic) NSPredicate * locationsPredicate;

- (NSURL *)storeURLFromPath:(NSString *)filePath;

// Invokes writeSafetyToURL method to save the persistant store in place.
- (BOOL)saveInPlace;

/**
 * Propts the user for an image filename,
 * only allowing one selection.  Returns the filename
 * stored within the wrapper, i.e. the name stored
 * in the database.
 *
 * Returns NIL if there is an error.
 */
- (NSString *)addPictureToWrapperUsingGPID:(NSString *)gpid forAttribute:(NSString *)attributeName;

@end
