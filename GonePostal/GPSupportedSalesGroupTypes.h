//
//  GPSupportedSalesGroupTypes.h
//  GonePostal
//
//  Created by Travis Gruber on 1/20/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedSalesGroupTypes : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@end
