//
//  LocalPrecancel.h
//  GonePostal
//
//  Created by Travis Gruber on 1/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPSalesGroup, Stamp;

@interface LocalPrecancel : NSManagedObject

@property (nonatomic, retain) NSString * cancel_style;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * gp_precancel_number;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * pss_type;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@end

@interface LocalPrecancel (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
