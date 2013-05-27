//
//  GPSetCounter.m
//  GonePostal
//
//  Created by Travis Gruber on 5/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSetCounter.h"

@implementation GPSetCounter

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSSet class]]) return nil;
    NSSet * theSet = value;
    
    NSNumber * rc = @([theSet count]);
    return rc;
}

@end
