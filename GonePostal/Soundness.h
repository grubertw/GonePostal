//
//  Soundness.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/15/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp;

@interface Soundness : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * abriviation;
@property (nonatomic, retain) NSString * soundness_description;
@property (nonatomic, retain) NSSet *stamps;
@end

@interface Soundness (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

@end
