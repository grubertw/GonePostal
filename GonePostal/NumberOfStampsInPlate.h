//
//  NumberOfStampsInPlate.h
//  GonePostal
//
//  Created by Travis Gruber on 7/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, StampFormat;

@interface NumberOfStampsInPlate : NSManagedObject

@property (nonatomic, retain) NSNumber * numberOfStamps;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) StampFormat *stampFormat;

@end
