//
//  PlateNumber+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 5/22/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "PlateNumber.h"

NS_ASSUME_NONNULL_BEGIN

@interface PlateNumber (CoreDataProperties)

@property (nullable, nonatomic, retain) NSNumber *combination_unknown;
@property (nullable, nonatomic, retain) NSString *gp_plate_combination_number;
@property (nullable, nonatomic, retain) NSString *imprint_1;
@property (nullable, nonatomic, retain) NSString *imprint_2;
@property (nullable, nonatomic, retain) NSString *marking;
@property (nullable, nonatomic, retain) NSNumber *max_percentage;
@property (nullable, nonatomic, retain) NSNumber *modifiedByUser;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSNumber *number_of_stamps;
@property (nullable, nonatomic, retain) NSString *picture;
@property (nullable, nonatomic, retain) NSString *plate1;
@property (nullable, nonatomic, retain) NSString *plate2;
@property (nullable, nonatomic, retain) NSString *plate3;
@property (nullable, nonatomic, retain) NSString *plate4;
@property (nullable, nonatomic, retain) NSString *plate5;
@property (nullable, nonatomic, retain) NSString *plate6;
@property (nullable, nonatomic, retain) NSString *plate7;
@property (nullable, nonatomic, retain) NSString *plate8;
@property (nullable, nonatomic, retain) NSNumber *unreported;
@property (nullable, nonatomic, retain) NSNumber *very_rare;
@property (nullable, nonatomic, retain) GPCatalog *gpCatalogEntry;
@property (nullable, nonatomic, retain) NSSet<PlatePosition *> *modifyingPlatePositions;
@property (nullable, nonatomic, retain) NSSet<PlatePositionInfo *> *platePositionInfos;
@property (nullable, nonatomic, retain) GPSalesGroup *salesGroup;
@property (nullable, nonatomic, retain) NSSet<Valuation *> *values;
@property (nullable, nonatomic, retain) NSSet<Stamp *> *stamps;

@end

@interface PlateNumber (CoreDataGeneratedAccessors)

- (void)addModifyingPlatePositionsObject:(PlatePosition *)value;
- (void)removeModifyingPlatePositionsObject:(PlatePosition *)value;
- (void)addModifyingPlatePositions:(NSSet<PlatePosition *> *)values;
- (void)removeModifyingPlatePositions:(NSSet<PlatePosition *> *)values;

- (void)addPlatePositionInfosObject:(PlatePositionInfo *)value;
- (void)removePlatePositionInfosObject:(PlatePositionInfo *)value;
- (void)addPlatePositionInfos:(NSSet<PlatePositionInfo *> *)values;
- (void)removePlatePositionInfos:(NSSet<PlatePositionInfo *> *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet<Valuation *> *)values;
- (void)removeValues:(NSSet<Valuation *> *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet<Stamp *> *)values;
- (void)removeStamps:(NSSet<Stamp *> *)values;

@end

NS_ASSUME_NONNULL_END
