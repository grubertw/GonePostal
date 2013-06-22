//
//  GPCatalogSet.h
//  GonePostal
//
//  Created by Travis Gruber on 6/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, GPCatalog, GPCatalogGroup, GPSalesGroup;

@interface GPCatalogSet : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) GPCatalogGroup *catalogGroup;
@end

@interface GPCatalogSet (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
