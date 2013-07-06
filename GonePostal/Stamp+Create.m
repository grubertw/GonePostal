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
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Stamp"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetch setPredicate:predicate];
    
    // Execute the query
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetch error:&error];
    if (results == nil) {
        NSLog(@"Error querying stamp %@, %@", error, [error userInfo]);
	    abort();
    }
    
    Stamp * newStamp = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:managedObjectContext];
    
    if (results && [results count] == 1) {
        Stamp * defaults = results[0];
        
        newStamp.address_type = defaults.address_type;
        newStamp.cancelation_date = defaults.cancelation_date;
        newStamp.cancelation_type = defaults.cancelation_type;
        newStamp.certificates = defaults.certificates;
        newStamp.faults = defaults.faults;
        newStamp.gp_stamp_number = defaults.gp_stamp_number;
        newStamp.history = defaults.history;
        newStamp.last_sale_price = defaults.last_sale_price;
        newStamp.manual_value = defaults.manual_value;
        newStamp.mint_used = defaults.mint_used;
        newStamp.plate_location = defaults.plate_location;
        newStamp.plate_position = defaults.plate_position;
        newStamp.purchase_amount = defaults.purchase_amount;
        newStamp.purchase_date = defaults.purchase_date;
        newStamp.source = defaults.source;
        
        newStamp.cancelQuality = defaults.cancelQuality;
        newStamp.centering = defaults.centering;
        newStamp.dealer = defaults.dealer;
        newStamp.format = defaults.format;
        newStamp.grade = defaults.grade;
        newStamp.gumCondition = defaults.gumCondition;
        newStamp.hinged = defaults.hinged;
        newStamp.location = defaults.location;
        newStamp.lot = defaults.lot;
        newStamp.mount = defaults.mount;
        newStamp.soundness = defaults.soundness;
    }
    
    return newStamp;
}

@end
