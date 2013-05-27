//
//  GPManualValueSummer.m
//  GonePostal
//
//  Created by Travis Gruber on 5/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPManualValueSummer.h"
#import "Stamp.h"

@implementation GPManualValueSummer

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSSet class]]) return nil;
    NSSet * stamps = value;
    
    float netWorth = 0.0;
    
    id obj = [stamps anyObject];
    if (obj != nil && [obj isMemberOfClass:[Stamp class]]) {
        for (Stamp * stamp in stamps) {
            netWorth += [stamp.manual_value floatValue];
        }
    }
    
    NSNumber * rc = @(netWorth);
    return rc;
}

@end
