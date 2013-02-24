//
//  Format.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/1/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface Format : NSManagedObject

@property (nonatomic, retain) NSString * formatName;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface Format (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
