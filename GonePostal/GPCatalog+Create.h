//
//  GPCatalog+Create.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalog.h"

@interface GPCatalog (Create)

/** Create From a defaults GPCatalog entry
 * Creates a new instance of GPCatalog from a "defaults" GPCatalog entry. 
 * There should only be one GPCatalog entry with is_default set to true.
 * If the defaults cannot be found, an empty GPCatalog entry is created.
 */
+ (GPCatalog *)createFromDefaultsUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

/** Create a subvariety based on a major variety.
 * Copies feilds from the major variety.  Sets the majorVariety reference.
 * Adds this subvariety into the major variety's set of subvarieties.
 */
+ (GPCatalog *)createFromMajorVariety:(GPCatalog *)theMajorVariety;

@end
