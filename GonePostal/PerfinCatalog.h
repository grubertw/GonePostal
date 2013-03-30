//
//  PerfinCatalog.h
//  GonePostal
//
//  Created by Travis Gruber on 3/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Perfin, PerfinCatalogName;

@interface PerfinCatalog : NSManagedObject

@property (nonatomic, retain) NSString * perfin_catalog_number;
@property (nonatomic, retain) PerfinCatalogName *catalogName;
@property (nonatomic, retain) NSSet *perfins;
@end

@interface PerfinCatalog (CoreDataGeneratedAccessors)

- (void)addPerfinsObject:(Perfin *)value;
- (void)removePerfinsObject:(Perfin *)value;
- (void)addPerfins:(NSSet *)values;
- (void)removePerfins:(NSSet *)values;

@end
