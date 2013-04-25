//
//  CancelQuality.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp;

@interface CancelQuality : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abriviation;
@property (nonatomic, retain) NSString * cq_description;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface CancelQuality (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
