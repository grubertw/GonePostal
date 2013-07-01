//
//  GPSupportedSubjects.h
//  GonePostal
//
//  Created by Travis Gruber on 6/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedSubjects : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@end
