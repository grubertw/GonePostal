//
//  GPManualValueSummer.m
//  GonePostal
//
//  Created by Travis Gruber on 5/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPManualValueSummer.h"
#import "GPCollection.h"
#import "Stamp.h"

@implementation GPManualValueSummer

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    float netWorth = 0.0;
    
    if ([value isKindOfClass:[GPCollection class]]) {
        GPCollection * collection = (GPCollection *)value;
        
        for (Stamp * stamp in collection.stamps) {
            netWorth += [self valueOfStamp:stamp];
        }
    }
    else if ([value isKindOfClass:[Stamp class]]) {
        Stamp * stamp = (Stamp *)value;
        netWorth = [self valueOfStamp:stamp];
    }
    
    NSNumber * rc = @(netWorth);
    return rc;
}

- (float)valueOfStamp:(Stamp *)stamp {
    float worth = 0;
    
    if ([stamp.children count] > 0) {
        for (Stamp * child in stamp.children) {
            worth += [child.manual_value floatValue];
        }
    }
    else {
        worth = [stamp.manual_value floatValue];
    }
    
    return worth;
}

@end
