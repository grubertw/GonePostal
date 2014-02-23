//
//  GPCatalogQuantityType.h
//  GonePostal
//
//  Created by Travis Gruber on 2/23/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalogQuantity;

@interface GPCatalogQuantityType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *quantities;
@end

@interface GPCatalogQuantityType (CoreDataGeneratedAccessors)

- (void)addQuantitiesObject:(GPCatalogQuantity *)value;
- (void)removeQuantitiesObject:(GPCatalogQuantity *)value;
- (void)addQuantities:(NSSet *)values;
- (void)removeQuantities:(NSSet *)values;

@end
