//
//  LocalPrecancel.h
//  GonePostal
//
//  Created by Travis Gruber on 3/10/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp;

@interface LocalPrecancel : NSManagedObject

@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) NSString * cancel_style;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * gp_precancel_number;
@property (nonatomic, retain) NSString * pss_type;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface LocalPrecancel (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
