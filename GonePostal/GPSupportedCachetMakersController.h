//
//  GPSupportedCachetMakersController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedCachetMakersController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

- (IBAction)addCachetMaker:(id)sender;
- (IBAction)removeCachetMaker:(id)sender;

@end
