//
//  GPEmptySetChecker.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/16/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPEmptySetChecker.h"

@implementation GPEmptySetChecker

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSSet class]]) return nil;

    NSSet * aSet = (NSSet *)value;
    NSNumber * setChk = [NSNumber numberWithBool:(aSet.count == 0)];
    
    return setChk;
}

@end
