//
//  Stamp.h
//  GonePostal
//
//  Created by Travis Gruber on 5/22/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BureauPrecancel, Cachet, CancelQuality, Centering, Dealer, GPCatalog, GPCollection, GPPicture, Grade, GumCondition, Hinged, LocalPrecancel, Location, Lot, Mount, Perfin, PlateNumber, SaleHistory, Soundness, StampFormat, GPCatalogSet;

NS_ASSUME_NONNULL_BEGIN

@interface Stamp : NSManagedObject

// Insert code here to declare functionality of your managed object subclass

@end

NS_ASSUME_NONNULL_END

#import "Stamp+CoreDataProperties.h"
