//
//  PlatePosition.h
//  GonePostal
//
//  Created by Travis Gruber on 8/4/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlateNumber, PlateUsage;

@interface PlatePosition : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *disallowedInPlateCombinations;
@property (nonatomic, retain) NSSet *plateUsage;
@end

@interface PlatePosition (CoreDataGeneratedAccessors)

- (void)addDisallowedInPlateCombinationsObject:(PlateNumber *)value;
- (void)removeDisallowedInPlateCombinationsObject:(PlateNumber *)value;
- (void)addDisallowedInPlateCombinations:(NSSet *)values;
- (void)removeDisallowedInPlateCombinations:(NSSet *)values;

- (void)addPlateUsageObject:(PlateUsage *)value;
- (void)removePlateUsageObject:(PlateUsage *)value;
- (void)addPlateUsage:(NSSet *)values;
- (void)removePlateUsage:(NSSet *)values;

@end
