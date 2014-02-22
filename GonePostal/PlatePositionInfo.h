//
//  PlatePositionInfo.h
//  GonePostal
//
//  Created by Travis Gruber on 2/18/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PlateNumber, PlatePosition;

@interface PlatePositionInfo : NSManagedObject

@property (nonatomic, retain) NSNumber * dissalowed;
@property (nonatomic, retain) NSNumber * maxPercentage;
@property (nonatomic, retain) NSNumber * unreported;
@property (nonatomic, retain) NSNumber * veryRare;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) PlatePosition *platePosition;
@property (nonatomic, retain) PlateNumber *plateCombination;

@end
