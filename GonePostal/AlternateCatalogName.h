//
//  AlternateCatalogName.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalog, GPCatalog;

@interface AlternateCatalogName : NSManagedObject

@property (nonatomic, retain) NSString * alternate_catalog_name;
@property (nonatomic, retain) NSSet *alternateCatalogs;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface AlternateCatalogName (CoreDataGeneratedAccessors)

- (void)addAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)removeAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)addAlternateCatalogs:(NSSet *)values;
- (void)removeAlternateCatalogs:(NSSet *)values;

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
