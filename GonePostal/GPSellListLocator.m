//
//  GPSellListLocator.m
//  GonePostal
//
//  Created by Travis Gruber on 5/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSellListLocator.h"
#import "GPCollection.h"
#import "GonePostal-Swift.h"

@implementation GPSellListLocator

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isKindOfClass:[NSSet class]]) return nil;
    NSSet * theSet = value;
    id collection = [theSet anyObject];
    
    NSString * rc;
    if (collection && [collection isMemberOfClass:[GPCollection class]]) {
        for (GPCollection * gpCollection in theSet) {
            if ([gpCollection.type isEqualToNumber:@(GPDocument.GP_COLLECTION_TYPE_SELL_LIST)]) {
                GPCollection * sellList = gpCollection;
                rc = sellList.name;
                break;
            }
        }
    }
    
    return rc;
}

@end
