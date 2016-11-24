//
//  GPCatalogSet+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 11/20/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "GPCatalogSet+CoreDataClass.h"


NS_ASSUME_NONNULL_BEGIN

@interface GPCatalogSet (CoreDataProperties)

+ (NSFetchRequest<GPCatalogSet *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *gp_set_number;
@property (nullable, nonatomic, copy) NSNumber *modifiedByUser;
@property (nullable, nonatomic, copy) NSString *name;
@property (nullable, nonatomic, copy) NSString *picture;
@property (nullable, nonatomic, retain) NSSet<Cachet *> *cachets;
@property (nullable, nonatomic, retain) GPCatalogGroup *catalogGroup;
@property (nullable, nonatomic, retain) Country *country;
@property (nullable, nonatomic, retain) NSSet<GPCatalog *> *gpCatalogEntries;
@property (nullable, nonatomic, retain) GPSalesGroup *salesGroup;
@property (nullable, nonatomic, retain) NSSet<Stamp *> *stamps;

@end

@interface GPCatalogSet (CoreDataGeneratedAccessors)

- (void)addCachetsObject:(Cachet *)value;
- (void)removeCachetsObject:(Cachet *)value;
- (void)addCachets:(NSSet<Cachet *> *)values;
- (void)removeCachets:(NSSet<Cachet *> *)values;

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet<GPCatalog *> *)values;
- (void)removeGpCatalogEntries:(NSSet<GPCatalog *> *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet<Stamp *> *)values;
- (void)removeStamps:(NSSet<Stamp *> *)values;

@end

NS_ASSUME_NONNULL_END
