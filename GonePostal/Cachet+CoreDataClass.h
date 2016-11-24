//
//  Cachet+CoreDataClass.h
//  GonePostal
//
//  Created by Travis Gruber on 11/14/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CachetCatalogName, CachetMakerName, GPCatalog, GPCatalogSet, GPSalesGroup, Stamp, Valuation;

NS_ASSUME_NONNULL_BEGIN

@interface Cachet : NSManagedObject

- (Cachet *) duplicate;

@end

NS_ASSUME_NONNULL_END

#import "Cachet+CoreDataProperties.h"
