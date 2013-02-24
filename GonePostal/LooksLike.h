//
//  LooksLike.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface LooksLike : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSSet *theseGPCatalogEntries;
@end

@interface LooksLike (CoreDataGeneratedAccessors)

- (void)addTheseGPCatalogEntriesObject:(GPCatalog *)value;
- (void)removeTheseGPCatalogEntriesObject:(GPCatalog *)value;
- (void)addTheseGPCatalogEntries:(NSSet *)values;
- (void)removeTheseGPCatalogEntries:(NSSet *)values;

@end
