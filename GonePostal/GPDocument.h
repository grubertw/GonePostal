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
extern const NSInteger CUSTOM_GP_CATALOG_SEARCH_ID; // Multiple predicates with diferent names share this ID.
extern const NSInteger CUSTOM_STAMP_SEARCH_ID;
extern const NSInteger ASSISTED_LOOKS_LIKE_BROWSER_SEARCH_ID;
extern const NSInteger ASSISTED_SETS_BROWSER_SEARCH_ID;
extern const NSInteger ASSISTED_LOOKS_LIKE_EDITOR_SEARCH_ID;
extern const NSInteger CUSTOM_PLATE_NUMBERS_SEARCH_ID;

extern const NSInteger GP_COLLECTION_TYPE_NORMAL;
extern const NSInteger GP_COLLECTION_TYPE_WANT_LIST;
extern const NSInteger GP_COLLECTION_TYPE_SELL_LIST;
extern const NSInteger GP_COLLECTION_TYPE_ITEMS_SOLD;

extern const NSInteger GPID_INCREMENT;

extern NSString * BASE_GP_CATALOG_QUERY;
extern NSString * BASE_GP_CATALOG_QUERY_WITH_SUBVARIETIES;

// Used when importing files into the GPWrapper.
typedef enum acceptedImportFileTypes {
    GPImportFileTypePicture,
    GPImportFileTypePDF
} GPImportFileType;

//
// Primay class of GonePostal
//
@interface GPDocument : NSPersistentDocument <NSTableViewDelegate>

/** Get a starting GPID.
 * Convert the last segment into a number that will be used in
 * subsquent calls as an increment.
 */
+ (NSInteger)parseStartingID:(NSString *)gpid;

/** Get the static part of the GPID from the GPID.
 * (the segments that will NOT increment)
 */
+ (NSString *)parseStaticID:(NSString *)gpid;

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
- (NSString *)addFileToWrapperUsingGPID:(NSString *)gpid forAttribute:(NSString *)attributeName fileType:(GPImportFileType)type;

/**
 * Creates a crypographic hash of the filename for a GPID.
 * The attribute field should objectify the GPID in some way,
 * such as the class name for the GPID in question.
 */
- (NSString *)hashFileNameForGPID:(NSString *)gpid andAttributeName:(NSString *)attributeName;

@end
