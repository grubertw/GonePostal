//
//  LooksLike.h
//  GonePostal
//
//  Created by Travis Gruber on 1/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, GPCatalog, GPCatalogGroup, GPSalesGroup;

@interface LooksLike : NSManagedObject

@property (nonatomic, retain) NSString * gp_lookslike_number;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) GPCatalogGroup *catalogGroup;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) NSSet *theseGPCatalogEntries;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@end

@interface LooksLike (CoreDataGeneratedAccessors)

- (void)addTheseGPCatalogEntriesObject:(GPCatalog *)value;
- (void)removeTheseGPCatalogEntriesObject:(GPCatalog *)value;
- (void)addTheseGPCatalogEntries:(NSSet *)values;
- (void)removeTheseGPCatalogEntries:(NSSet *)values;

@end
