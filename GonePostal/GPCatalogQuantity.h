//
//  GPCatalogQuantity.h
//  GonePostal
//
//  Created by Travis Gruber on 2/23/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogQuantityType;

@interface GPCatalogQuantity : NSManagedObject

@property (nonatomic, retain) NSNumber * quantity;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) GPCatalogQuantityType *quantityType;
@property (nonatomic, retain) NSSet *catalogEntries;
@end

@interface GPCatalogQuantity (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
