//
//  PlateUsage.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/15/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, PlatePosition;

@interface PlateUsage : NSManagedObject

@property (nonatomic, retain) NSNumber * plate_number;
@property (nonatomic, retain) NSString * plate_usage_name;
@property (nonatomic, retain) NSString * usage_color;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;
@property (nonatomic, retain) NSSet *platePositions;
@end

@interface PlateUsage (CoreDataGeneratedAccessors)

- (void)addPlatePositionsObject:(PlatePosition *)value;
- (void)removePlatePositionsObject:(PlatePosition *)value;
- (void)addPlatePositions:(NSSet *)values;
- (void)removePlatePositions:(NSSet *)values;

@end
