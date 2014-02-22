//
//  GPSupportedCatalogPeopleTypes.h
//  GonePostal
//
//  Created by Travis Gruber on 2/21/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedCatalogPeopleTypes : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@end
