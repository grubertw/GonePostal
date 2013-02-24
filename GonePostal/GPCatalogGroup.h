//
//  GPCatalogGroup.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface GPCatalogGroup : NSManagedObject

@property (nonatomic, retain) NSString * group_name;
@property (nonatomic, retain) NSString * group_number;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface GPCatalogGroup (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
