//
//  Perfin.h
//  GonePostal
//
//  Created by Travis Gruber on 3/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class PerfinCatalog, PerfinCatalogName, Stamp;

@interface Perfin : NSManagedObject

@property (nonatomic, retain) NSString * additional_info;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * company_name;
@property (nonatomic, retain) NSNumber * company_verified;
@property (nonatomic, retain) NSString * general_or_revenue;
@property (nonatomic, retain) NSString * gp_perfin_number;
@property (nonatomic, retain) NSString * letter_height;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * number_of_holes;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSNumber * precancel;
@property (nonatomic, retain) NSString * punch_description;
@property (nonatomic, retain) NSString * scarcity_rating;
@property (nonatomic, retain) NSString * time_frame;
@property (nonatomic, retain) NSSet *alternateCatalogs;
@property (nonatomic, retain) PerfinCatalogName *defaultCatalog;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface Perfin (CoreDataGeneratedAccessors)

- (void)addAlternateCatalogsObject:(PerfinCatalog *)value;
- (void)removeAlternateCatalogsObject:(PerfinCatalog *)value;
- (void)addAlternateCatalogs:(NSSet *)values;
- (void)removeAlternateCatalogs:(NSSet *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
