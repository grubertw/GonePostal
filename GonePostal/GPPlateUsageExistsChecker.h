//
//  GPPlateUsageExistsChecker.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/18/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPPlateUsageExistsChecker : NSValueTransformer

@property (strong, nonatomic) NSNumber * plateNumberToCheck;

- (id)initWithPlateNumberCheck:(NSNumber *)plateNumber;

@end
