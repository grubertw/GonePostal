//
//  AlternateCatalog.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalogGroup, AlternateCatalogName, GPCatalog;

@interface AlternateCatalog : NSManagedObject

@property (nonatomic, retain) NSString * alternate_catalog_number;
@property (nonatomic, retain) AlternateCatalogGroup *alternateCatalogGroup;
@property (nonatomic, retain) AlternateCatalogName *alternateCatalogName;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface AlternateCatalog (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
