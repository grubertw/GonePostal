//
//  GPPlateUsageExistsChecker.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/18/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateUsageExistsChecker.h"
#import "PlateUsage.h"

@implementation GPPlateUsageExistsChecker

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)initWithPlateNumberCheck:(NSNumber *)plateNumber
{
    self = [super init];
    if (self) {
        self.plateNumberToCheck = plateNumber;
    }
    return self;
}

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    NSSet * plateUsages = (NSSet *)value;
    if (plateUsages == nil) return nil;

    NSEnumerator * e = plateUsages.objectEnumerator;
    id usageID;
    while ( (usageID = [e nextObject]) ) {
        PlateUsage * plateUsage = (PlateUsage *)usageID;
        if (plateUsage == nil) return nil;
        else if ([plateUsage.plate_number isEqualToNumber:self.plateNumberToCheck]) {
            return [NSNumber numberWithBool:YES];
        }
        
    }
    
    return [NSNumber numberWithBool:NO];
}

@end
