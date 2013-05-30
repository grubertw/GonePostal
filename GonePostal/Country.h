//
//  Country.h
//  GonePostal
//
//  Created by Travis Gruber on 5/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, LooksLike;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * country_name;
@property (nonatomic, retain) NSNumber * country_sort_id;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) NSSet *looksLikes;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addLooksLikesObject:(LooksLike *)value;
- (void)removeLooksLikesObject:(LooksLike *)value;
- (void)addLooksLikes:(NSSet *)values;
- (void)removeLooksLikes:(NSSet *)values;

@end
