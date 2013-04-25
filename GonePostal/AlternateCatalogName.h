//
//  AlternateCatalogName.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalog, GPCatalog;

@interface AlternateCatalogName : NSManagedObject

@property (nonatomic, retain) NSString * alternate_catalog_name;
@property (nonatomic, retain) NSString * abriviation;
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
