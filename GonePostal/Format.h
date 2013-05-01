//
//  Format.h
//  GonePostal
//
//  Created by Travis Gruber on 4/28/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, StampFormat;

@interface Format : NSManagedObject

@property (nonatomic, retain) NSString * formatName;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) NSSet *allowedStampFormats;
@end

@interface Format (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addAllowedStampFormatsObject:(StampFormat *)value;
- (void)removeAllowedStampFormatsObject:(StampFormat *)value;
- (void)addAllowedStampFormats:(NSSet *)values;
- (void)removeAllowedStampFormats:(NSSet *)values;

@end
