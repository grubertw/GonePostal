//
//  Cachet+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 11/14/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "Cachet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface Cachet (CoreDataProperties)

+ (NSFetchRequest<Cachet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *alternate_picture_1;
@property (nullable, nonatomic, copy) NSString *alternate_picture_2;
@property (nullable, nonatomic, copy) NSString *alternate_picture_3;
@property (nullable, nonatomic, copy) NSString *alternate_picture_4;
@property (nullable, nonatomic, copy) NSString *alternate_picture_5;
@property (nullable, nonatomic, copy) NSString *alternate_picture_6;
@property (nullable, nonatomic, copy) NSString *cachet_description;
@property (nullable, nonatomic, copy) NSString *cachet_picture;
@property (nullable, nonatomic, copy) NSString *cachet_type;
@property (nullable, nonatomic, copy) NSString *color;
@property (nullable, nonatomic, copy) NSString *design_description;
@property (nullable, nonatomic, copy) NSString *external_catalog_number;
@property (nullable, nonatomic, copy) NSNumber *first_cachet;
@property (nullable, nonatomic, copy) NSString *gp_cachet_number;
@property (nullable, nonatomic, copy) NSNumber *modifiedByUser;
@property (nullable, nonatomic, retain) CachetCatalogName *cachetCatalog;
@property (nullable, nonatomic, retain) CachetMakerName *cachetMakerName;
@property (nullable, nonatomic, retain) GPCatalog *gpCatalog;
@property (nullable, nonatomic, retain) GPSalesGroup *salesGroup;
@property (nullable, nonatomic, retain) NSSet<Stamp *> *stamps;
@property (nullable, nonatomic, retain) NSSet<Valuation *> *values;
@property (nullable, nonatomic, retain) GPCatalogSet *gpCatalogSet;

@end

@interface Cachet (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet<Stamp *> *)values;
- (void)removeStamps:(NSSet<Stamp *> *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet<Valuation *> *)values;
- (void)removeValues:(NSSet<Valuation *> *)values;

@end

NS_ASSUME_NONNULL_END
