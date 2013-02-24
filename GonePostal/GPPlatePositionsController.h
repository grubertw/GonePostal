//
//  GPPlatePositionsController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPPlatePositionsController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

- (IBAction)addPlatePosition:(id)sender;
- (IBAction)deletePlatePosition:(id)sender;

@end
