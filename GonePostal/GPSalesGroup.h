//
//  GPSalesGroup.h
//  GonePostal
//
//  Created by Travis Gruber on 5/16/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, Perfin;

@interface GPSalesGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSDate * lastDateUpdated;
@property (nonatomic, retain) NSNumber * salesID;
@property (nonatomic, retain) NSString * purchaseKey;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) NSSet *perfinEntries;
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

@end
