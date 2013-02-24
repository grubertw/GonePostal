//
//  GPPlateUsageController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlatePosition.h"

@interface GPPlateUsageController : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * platePositionsSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * platePositionsInPlateUsageController;
@property (weak, nonatomic) IBOutlet NSArrayController * platePositionsController;

@property (strong, nonatomic) PlatePosition * selectedPlatePosition;

- (IBAction)addPlatePositionToPlateUsage:(id)sender;
- (IBAction)removePlatePositionFromPlateUsage:(id)sender;

@end
