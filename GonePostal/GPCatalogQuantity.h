//
//  GPCatalogQuantity.h
//  GonePostal
//
//  Created by Travis Gruber on 1/22/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogQuantityType;

@interface GPCatalogQuantity : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) GPCatalogQuantityType *quantityType;
@end

@interface GPCatalogQuantity (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
