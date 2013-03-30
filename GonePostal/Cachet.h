//
//  Cachet.h
//  GonePostal
//
//  Created by Travis Gruber on 3/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CachetCatalogName, CachetMakerName, GPCatalog, Stamp;

@interface Cachet : NSManagedObject

@property (nonatomic, retain) NSString * alternate_picture_1;
@property (nonatomic, retain) NSString * alternate_picture_2;
@property (nonatomic, retain) NSString * alternate_picture_3;
@property (nonatomic, retain) NSString * alternate_picture_4;
@property (nonatomic, retain) NSString * alternate_picture_5;
@property (nonatomic, retain) NSString * alternate_picture_6;
@property (nonatomic, retain) NSString * cachet_description;
@property (nonatomic, retain) NSString * cachet_picture;
@property (nonatomic, retain) NSString * cachet_type;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSString * design_description;
@property (nonatomic, retain) NSString * external_catalog_number;
@property (nonatomic, retain) NSNumber * first_cachet;
@property (nonatomic, retain) NSString * gp_cachet_number;
@property (nonatomic, retain) CachetCatalogName *cachetCatalog;
@property (nonatomic, retain) CachetMakerName *cachetMakerName;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface Cachet (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
