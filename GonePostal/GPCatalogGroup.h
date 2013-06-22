//
//  GPCatalogGroup.h
//  GonePostal
//
//  Created by Travis Gruber on 6/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogSet, GPSalesGroup, LooksLike;

@interface GPCatalogGroup : NSManagedObject

@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSString * group_number;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) NSSet *looksLikes;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@property (nonatomic, retain) NSSet *gpCatalogSets;
@end

@interface GPCatalogGroup (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addLooksLikesObject:(LooksLike *)value;
- (void)removeLooksLikesObject:(LooksLike *)value;
- (void)addLooksLikes:(NSSet *)values;
- (void)removeLooksLikes:(NSSet *)values;

- (void)addGpCatalogSetsObject:(GPCatalogSet *)value;
- (void)removeGpCatalogSetsObject:(GPCatalogSet *)value;
- (void)addGpCatalogSets:(NSSet *)values;
- (void)removeGpCatalogSets:(NSSet *)values;

@end
