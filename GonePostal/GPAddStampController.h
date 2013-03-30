//
//  GPAddStampController.h
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCollection.h"
#import "GPLocatorPage.h"
#import "GPCatalogChooserPage.h"
#import "GPNewStampPage.h"

@interface GPAddStampController : NSWindowController <NSPageControllerDelegate>

@property (strong, nonatomic) GPCollection * myCollection;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) GPLocatorPage * gpLocatorPage;
@property (strong, nonatomic) GPCatalogChooserPage * gpCatalogPage;
@property (strong, nonatomic) GPNewStampPage * gpNewStampPage;

@property (strong, nonatomic) LooksLike * selectedLooksLike;
@property (strong, nonatomic) GPCatalog * selectedGPCatalog;

/** Initializes the wizard enabling the user add a stamp to their collection.
 *
 * This wizard can run in 1 of 2 modes:
 * - mode 1 = with the LooksLike locator
 * - mode 2 = without the LooksLike locator (skips directly to GPCatalog chooser)
 */
- (id)initWithCollection:(GPCollection *)myCollection operatingMode:(NSUInteger)mode;

@end
