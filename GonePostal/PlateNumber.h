//
//  PlateNumber.h
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, PlatePosition;

@interface PlateNumber : NSManagedObject

@property (nonatomic, retain) NSNumber * combination_unknown;
@property (nonatomic, retain) NSString * imprint_1;
@property (nonatomic, retain) NSString * imprint_2;
@property (nonatomic, retain) NSString * marking;
@property (nonatomic, retain) NSNumber * max_percentage;
@property (nonatomic, retain) NSNumber * number_of_stamps;
@property (nonatomic, retain) NSString * plate1;
@property (nonatomic, retain) NSString * plate2;
@property (nonatomic, retain) NSString * plate3;
@property (nonatomic, retain) NSString * plate4;
@property (nonatomic, retain) NSString * plate5;
@property (nonatomic, retain) NSString * plate6;
@property (nonatomic, retain) NSString * plate7;
@property (nonatomic, retain) NSString * plate8;
@property (nonatomic, retain) NSNumber * very_rare;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * gp_plate_combination_number;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * unreported;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;
@property (nonatomic, retain) NSSet *disallowedPlatePositions;
@end

@interface PlateNumber (CoreDataGeneratedAccessors)

- (void)addDisallowedPlatePositionsObject:(PlatePosition *)value;
- (void)removeDisallowedPlatePositionsObject:(PlatePosition *)value;
- (void)addDisallowedPlatePositions:(NSSet *)values;
- (void)removeDisallowedPlatePositions:(NSSet *)values;

@end
