//
//  GPPlateNumberMasterDisplayTransformer.m
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateNumberMasterDisplayTransformer.h"
#import "GPCatalog.h"
#import "PlateNumber.h"
#import "PlateUsage.h"

@implementation GPPlateNumberMasterDisplayTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    if (![value isMemberOfClass:[PlateNumber class]]) return nil;
    
    PlateNumber * plateCombo = value;
    
    NSUInteger plateUsageCount = [plateCombo.gpCatalogEntry.plateUsage count];
    
    NSMutableString * outputString = [[NSMutableString alloc] initWithCapacity:0];
    
    for (NSInteger i=0; i<plateUsageCount; i++) {
        if      (i == 0 && plateCombo.plate1)
            [outputString appendString:plateCombo.plate1];
        else if (i == 1 && plateCombo.plate2)
            [outputString appendString:plateCombo.plate2];
        else if (i == 2 && plateCombo.plate3)
            [outputString appendString:plateCombo.plate3];
        else if (i == 3 && plateCombo.plate4)
            [outputString appendString:plateCombo.plate4];
        else if (i == 4 && plateCombo.plate5)
            [outputString appendString:plateCombo.plate5];
        else if (i == 5 && plateCombo.plate6)
            [outputString appendString:plateCombo.plate6];
        else if (i == 6 && plateCombo.plate7)
            [outputString appendString:plateCombo.plate7];
        else if (i == 7 && plateCombo.plate8)
            [outputString appendString:plateCombo.plate8];
        
        if (i != plateUsageCount-1) {
            [outputString appendString:@" - "];
        }
    }
    
    return outputString;
}

@end
