//
//  GPCompositeTypeTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 5/31/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCompositeTypeTransformer.h"
#import "Stamp+CreateComposite.h"

@implementation GPCompositeTypeTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isMemberOfClass:[Stamp class]]) return nil;
    
    Stamp * composite = value;
    NSString * rc = @"";
    
    if ([composite.parentType isEqualToNumber:@(COMPOSITE_TYPE_MULTI_QUANTITY)]) {
        rc = @"Multi-Quantity Composite";
    }
    else if ([composite.parentType isEqualToNumber:@(COMPOSITE_TYPE_SET)]) {
        rc = @"Set Composite";
    }
    else if ([composite.parentType isEqualToNumber:@(COMPOSITE_TYPE_INTEGRAL)]){
        rc = @"Integral Compsite";
    }
    
    return rc;
}

@end
