//
//  PlatePosition.h
//  GonePostal
//
//  Created by Travis Gruber on 1/28/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlateNumber, PlateUsage;

@interface PlatePosition : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * max_percentage;
@property (nonatomic, retain) NSNumber * very_rare;
@property (nonatomic, retain) NSNumber * unreported;
@property (nonatomic, retain) NSNumber * disallowed;
@property (nonatomic, retain) NSSet *modifiesThesePlateCombinations;
@property (nonatomic, retain) NSSet *plateUsage;
@end

@interface PlatePosition (CoreDataGeneratedAccessors)

- (void)addModifiesThesePlateCombinationsObject:(PlateNumber *)value;
- (void)removeModifiesThesePlateCombinationsObject:(PlateNumber *)value;
- (void)addModifiesThesePlateCombinations:(NSSet *)values;
- (void)removeModifiesThesePlateCombinations:(NSSet *)values;

- (void)addPlateUsageObject:(PlateUsage *)value;
- (void)removePlateUsageObject:(PlateUsage *)value;
- (void)addPlateUsage:(NSSet *)values;
- (void)removePlateUsage:(NSSet *)values;

@end
