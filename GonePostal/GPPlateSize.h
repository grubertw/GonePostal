//
//  GPPlateSize.h
//  GonePostal
//
//  Created by Travis Gruber on 1/22/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPPlateSizeType;

@interface GPPlateSize : NSManagedObject

@property (nonatomic, retain) NSNumber * coilLength;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) NSNumber * numberOfPanes;
@property (nonatomic, retain) NSNumber * paneHeight;
@property (nonatomic, retain) NSNumber * paneSize;
@property (nonatomic, retain) NSNumber * paneWidth;
@property (nonatomic, retain) NSNumber * plateSize;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) GPPlateSizeType *plateSizeType;
@end

@interface GPPlateSize (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
