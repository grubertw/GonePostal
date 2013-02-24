//
//  CachetCatalogName.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cachet;

@interface CachetCatalogName : NSManagedObject

@property (nonatomic, retain) NSString * cachet_catalog_name;
@property (nonatomic, retain) NSSet *cachets;
@end

@interface CachetCatalogName (CoreDataGeneratedAccessors)

- (void)addCachetsObject:(Cachet *)value;
- (void)removeCachetsObject:(Cachet *)value;
- (void)addCachets:(NSSet *)values;
- (void)removeCachets:(NSSet *)values;

@end
