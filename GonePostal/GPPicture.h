//
//  GPPicture.h
//  GonePostal
//
//  Created by Travis Gruber on 4/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, PictureType, Stamp;

@interface GPPicture : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * is_default;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) PictureType *pictureType;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface GPPicture (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
