//
//  Topic.h
//  GonePostal
//
//  Created by Travis Gruber on 1/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPSalesGroup;

@interface Topic : NSManagedObject

@property (nonatomic, retain) NSString * topic_description;
@property (nonatomic, retain) NSString * topic_name;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@end

@interface Topic (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
