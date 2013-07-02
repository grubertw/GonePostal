//
//  StampFormat.h
//  GonePostal
//
//  Created by Travis Gruber on 7/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Format, NumberOfStampsInPlate, Stamp;

@interface StampFormat : NSManagedObject

@property (nonatomic, retain) NSNumber * displayBureauPrecancelInfo;
@property (nonatomic, retain) NSNumber * displayCachetInfo;
@property (nonatomic, retain) NSNumber * displayCancelationInfo;
@property (nonatomic, retain) NSNumber * displayLocalPrecancelInfo;
@property (nonatomic, retain) NSNumber * displayPerfinInfo;
@property (nonatomic, retain) NSNumber * displayPlateInfo;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *containers;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *numberOfStampCombinations;
@end

@interface StampFormat (CoreDataGeneratedAccessors)

- (void)addContainersObject:(Format *)value;
- (void)removeContainersObject:(Format *)value;
- (void)addContainers:(NSSet *)values;
- (void)removeContainers:(NSSet *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addNumberOfStampCombinationsObject:(NumberOfStampsInPlate *)value;
- (void)removeNumberOfStampCombinationsObject:(NumberOfStampsInPlate *)value;
- (void)addNumberOfStampCombinations:(NSSet *)values;
- (void)removeNumberOfStampCombinations:(NSSet *)values;

@end
