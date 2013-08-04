//
//  Centering.h
//  GonePostal
//
//  Created by Travis Gruber on 8/4/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp, Valuation;

@interface Centering : NSManagedObject

@property (nonatomic, retain) NSString * abriviation;
@property (nonatomic, retain) NSString * centering_description;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *values;
@end

@interface Centering (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
