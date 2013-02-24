//
//  GPSupportedGroupsController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedGroupsController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

- (IBAction)addGroup:(id)sender;
- (IBAction)deleteGroup:(id)sender;

@end
