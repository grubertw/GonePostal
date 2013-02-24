//
//  GPDocument.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>


@interface GPDocument : NSPersistentDocument

- (IBAction)openGPCatalogEditor:(id)sender;

- (void)openGPCatalogDefaults:(id)sender;

- (void)editSupportedCountries:(id)sender;
- (void)editSupportedFormats:(id)sender;
- (void)editSupportedAltCatalogNames:(id)sender;
- (void)editSupportedAltCatalogSections:(id)sender;
- (void)editSupportedGroups:(id)sender;
- (void)editSupportedPlatePositions:(id)sender;
- (void)editSupportedCachetCatalogs:(id)sender;
- (void)editSupportedCachetMakers:(id)sender;

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
- (NSString *)addPictureToWrapper;

@end
