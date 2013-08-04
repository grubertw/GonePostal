//
//  BureauPrecancel.h
//  GonePostal
//
//  Created by Travis Gruber on 8/4/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, Stamp, Valuation;

@interface BureauPrecancel : NSManagedObject

@property (nonatomic, retain) NSString * cancel_style;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * gp_precancel_number;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * pss_type;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * variety_description;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *values;
@end

@interface BureauPrecancel (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
