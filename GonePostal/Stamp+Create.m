//
//  Stamp+Create.m
//  GonePostal
//
//  Created by Travis Gruber on 7/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp+Create.h"

@implementation Stamp (Create)

+ (Stamp *)CreateFromDefaultsUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    Stamp * newStamp = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:managedObjectContext];
    
    [newStamp setToDefaults];
    return newStamp;
}

- (void)setToDefaults {
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Stamp"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetch setPredicate:predicate];
    
    // Execute the query
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:&error];
    if (results == nil) {
        NSLog(@"Error querying stamp %@, %@", error, [error userInfo]);
	    abort();
    }
    
    if (results && [results count] == 1) {
        Stamp * defaults = results[0];
        
        self.address_type = defaults.address_type;
        self.cancelation_date = defaults.cancelation_date;
        self.cancelation_type = defaults.cancelation_type;
        self.certificates = defaults.certificates;
        self.faults = defaults.faults;
        self.gp_stamp_number = defaults.gp_stamp_number;
        self.history = defaults.history;
        self.last_sale_price = defaults.last_sale_price;
        self.manual_value = defaults.manual_value;
        self.mint_used = defaults.mint_used;
        self.plate_location = defaults.plate_location;
        self.plate_position = defaults.plate_position;
        self.purchase_amount = defaults.purchase_amount;
        self.purchase_date = defaults.purchase_date;
        self.source = defaults.source;
        
        self.cancelQuality = defaults.cancelQuality;
        self.centering = defaults.centering;
        self.dealer = defaults.dealer;
        self.format = defaults.format;
        self.grade = defaults.grade;
        self.gumCondition = defaults.gumCondition;
        self.hinged = defaults.hinged;
        self.location = defaults.location;
        self.lot = defaults.lot;
        self.mount = defaults.mount;
        self.soundness = defaults.soundness;
    }
}

@end
