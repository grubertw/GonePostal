//
//  GPSearchSelectionTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 3/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSearchSelectionTransformer.h"
#import "Country.h"
#import "GPCatalogGroup.h"

@implementation GPSearchSelectionTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSArray class]]) return nil;
    
    NSArray * searchNames = (NSArray *)value;
    NSString * searchName = @"all";
    
    if (searchNames.count == 1) {
        // Check to see if the object in the array is
        // a supported type.
        id searchObject = [searchNames objectAtIndex:0];
        if ([searchObject isMemberOfClass:[Country class]]) {
            searchName = ((Country *)searchObject).country_name;
        }
        else if ([searchObject isMemberOfClass:[GPCatalogGroup class]]) {
            searchName = ((GPCatalogGroup *)searchObject).group_name;
        }
        else {
            searchName = @"one";
        }
    }
    else if (searchNames.count > 1) {
        searchName = @"some";
    }
    
    return searchName;
}

@end
