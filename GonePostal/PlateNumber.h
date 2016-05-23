//
//  PlateNumber.h
//  GonePostal
//
//  Created by Travis Gruber on 5/22/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPSalesGroup, PlatePosition, PlatePositionInfo, Stamp, Valuation;

NS_ASSUME_NONNULL_BEGIN

@interface PlateNumber : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "PlateNumber+CoreDataProperties.h"
