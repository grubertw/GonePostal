//
//  PlatePosition.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlateUsage;

@interface PlatePosition : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *plateUsage;
@end

@interface PlatePosition (CoreDataGeneratedAccessors)

- (void)addPlateUsageObject:(PlateUsage *)value;
- (void)removePlateUsageObject:(PlateUsage *)value;
- (void)addPlateUsage:(NSSet *)values;
- (void)removePlateUsage:(NSSet *)values;

@end
