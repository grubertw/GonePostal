//
//  BureauPrecancel+Duplicate.m
//  GonePostal
//
//  Created by Travis Gruber on 4/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "BureauPrecancel+Duplicate.h"

@implementation BureauPrecancel (Duplicate)

- (BureauPrecancel *)duplicate {
    BureauPrecancel * dup = [NSEntityDescription insertNewObjectForEntityForName:@"BureauPrecancel" inManagedObjectContext:self.managedObjectContext];
    
    dup.gp_precancel_number = self.gp_precancel_number;
    dup.city = self.city;
    dup.state = self.state;
    dup.cancel_style = self.cancel_style;
    dup.pss_type = self.pss_type;
    dup.salesGroup = self.salesGroup;
    
    return dup;
}

@end
