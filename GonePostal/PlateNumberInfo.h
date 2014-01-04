//
//  PlateNumberInfo.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface PlateNumberInfo : NSManagedObject

@property (nonatomic, retain) NSString * plate_color;
@property (nonatomic, retain) NSString * plate_sequence;
@property (nonatomic, retain) NSString * plate_usage;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface PlateNumberInfo (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
