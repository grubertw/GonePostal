//
//  GPStampHasChildrenOrDetailTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 5/31/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampHasChildrenOrDetailTransformer.h"
#import "Stamp.h"

@implementation GPStampHasChildrenOrDetailTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isMemberOfClass:[Stamp class]]) return nil;
    
    Stamp * stamp = value;
    NSString * rc = @"";
    
    if ([stamp.children count] > 0) {
        rc = @"Show Children";
    }
    else {
        rc = @"Detail";
    }
    
    return rc;
}

@end
