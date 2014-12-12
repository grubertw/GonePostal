//
//  GPAllowedStampFormatsTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 12/11/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPAllowedStampFormatsTransformer.h"

#import "StampFormat.h"

@implementation GPAllowedStampFormatsTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSSet class]]) return nil;
    NSSet * theSet = value;
    
    // Generate a comma deleniated list of the allowed stamps formats within the GPCatalog.
    NSMutableString * delimitedString = [[NSMutableString alloc] initWithCapacity:0];
    for (StampFormat * format in theSet) {
        [delimitedString appendFormat:@"%@, ", format.name];
    }
    
    // Delete the ", " at the end.
    if ([theSet count] > 1 && [delimitedString length] > 2) {
        NSRange deleteTrailingCharsRange;
        deleteTrailingCharsRange.length = 2;
        deleteTrailingCharsRange.location = [delimitedString length] - 2;
        [delimitedString deleteCharactersInRange:deleteTrailingCharsRange];
    }
    
    return delimitedString;
}

@end
