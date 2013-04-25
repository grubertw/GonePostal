//
//  AlternateCatalogGroup.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalog;

@interface AlternateCatalogGroup : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * sort_id;
@property (nonatomic, retain) NSString * abriviation;
@property (nonatomic, retain) NSSet *alternateCatalogs;
@end

@interface AlternateCatalogGroup (CoreDataGeneratedAccessors)

- (void)addAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)removeAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)addAlternateCatalogs:(NSSet *)values;
- (void)removeAlternateCatalogs:(NSSet *)values;

@end
