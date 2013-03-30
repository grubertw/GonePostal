//
//  GPMultipleSelectionChecker.m
//  GonePostal
//
//  Created by Travis Gruber on 3/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPMultipleSelectionChecker.h"

@implementation GPMultipleSelectionChecker

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSArray class]]) return nil;
    
    NSArray * anArray = (NSArray *)value;
    BOOL multVals = [anArray count] > 1;
    
    NSNumber * chk = @(!multVals);
    return chk;
}

@end
