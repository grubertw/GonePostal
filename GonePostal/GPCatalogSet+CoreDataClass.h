//
//  GPCatalogSet+CoreDataClass.h
//  GonePostal
//
//  Created by Travis Gruber on 11/14/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cachet, Country, GPCatalog, GPCatalogGroup, GPSalesGroup, Stamp;

NS_ASSUME_NONNULL_BEGIN

@interface GPCatalogSet : NSManagedObject

@end

NS_ASSUME_NONNULL_END

#import "GPCatalogSet+CoreDataProperties.h"
