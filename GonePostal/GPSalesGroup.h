//
//  GPSalesGroup.h
//  GonePostal
//
//  Created by Travis Gruber on 6/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogGroup, GPCatalogSet, Perfin;

@interface GPSalesGroup : NSManagedObject

@property (nonatomic, retain) NSDate * lastDateUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * purchaseKey;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSNumber * salesID;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) NSSet *perfinEntries;
@property (nonatomic, retain) NSSet *catalogGroups;
@property (nonatomic, retain) NSSet *catalogSets;
@end

@interface GPSalesGroup (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

- (void)addPerfinEntriesObject:(Perfin *)value;
- (void)removePerfinEntriesObject:(Perfin *)value;
- (void)addPerfinEntries:(NSSet *)values;
- (void)removePerfinEntries:(NSSet *)values;

- (void)addCatalogGroupsObject:(GPCatalogGroup *)value;
- (void)removeCatalogGroupsObject:(GPCatalogGroup *)value;
- (void)addCatalogGroups:(NSSet *)values;
- (void)removeCatalogGroups:(NSSet *)values;

- (void)addCatalogSetsObject:(GPCatalogSet *)value;
- (void)removeCatalogSetsObject:(GPCatalogSet *)value;
- (void)addCatalogSets:(NSSet *)values;
- (void)removeCatalogSets:(NSSet *)values;

@end
