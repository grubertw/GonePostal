//
//  PerfinCatalogName.h
//  GonePostal
//
//  Created by Travis Gruber on 3/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Perfin, PerfinCatalog;

@interface PerfinCatalogName : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *perfinCatalogs;
@property (nonatomic, retain) NSSet *perfins;
@end

@interface PerfinCatalogName (CoreDataGeneratedAccessors)

- (void)addPerfinCatalogsObject:(PerfinCatalog *)value;
- (void)removePerfinCatalogsObject:(PerfinCatalog *)value;
- (void)addPerfinCatalogs:(NSSet *)values;
- (void)removePerfinCatalogs:(NSSet *)values;

- (void)addPerfinsObject:(Perfin *)value;
- (void)removePerfinsObject:(Perfin *)value;
- (void)addPerfins:(NSSet *)values;
- (void)removePerfins:(NSSet *)values;

@end
