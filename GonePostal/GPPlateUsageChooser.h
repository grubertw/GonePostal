//
//  GPPlateUsageChooser.h
//  GonePostal
//
//  Created by Travis Gruber on 3/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PlatePosition.h"

@interface GPPlateUsageChooser : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (strong, nonatomic) PlatePosition * selectedPlatePosition;

@end
