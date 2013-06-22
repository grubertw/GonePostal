//
//  GPStampDescriptionTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 6/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampDescriptionTransformer.h"
#import "Stamp.h"
#import "GPCatalog.h"

@implementation GPStampDescriptionTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isMemberOfClass:[Stamp class]]) return nil;
    
    Stamp * stamp = value;
    NSString * rc = @"";
    
    if ([stamp.children count] > 0) {
        rc = stamp.composite_description;
    }
    else {
        rc = stamp.gpCatalog.gp_description;
    }
    
    return rc;
}

@end
