//
//  Stamp+Duplicate.m
//  GonePostal
//
//  Created by Travis Gruber on 7/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp+Duplicate.h"

@implementation Stamp (Duplicate)

- (Stamp *)duplicate {
    Stamp * dup = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:self.managedObjectContext];
    
    dup.address_type = self.address_type;
    dup.catalog_value = self.catalog_value;
    dup.cancelation_date = self.cancelation_date;
    dup.cancelation_type = self.cancelation_type;
    dup.census_id = self.census_id;
    dup.certificates = self.certificates;
    dup.faults = self.faults;
    dup.history = self.history;
    dup.inprint_1 = self.inprint_1;
    dup.inprint_2 = self.inprint_2;
    dup.inventory_number = self.inventory_number;
    dup.last_sale_price = self.last_sale_price;
    dup.manual_value = self.manual_value;
    dup.manual_value_overrides_catalog_value = self.manual_value_overrides_catalog_value;
    dup.mint_used = self.mint_used;
    dup.notes = self.notes;
    dup.plate_1 = self.plate_1;
    dup.plate_2 = self.plate_2;
    dup.plate_3 = self.plate_3;
    dup.plate_4 = self.plate_4;
    dup.plate_5 = self.plate_5;
    dup.plate_6 = self.plate_6;
    dup.plate_7 = self.plate_7;
    dup.plate_8 = self.plate_8;
    dup.plate_location = self.plate_location;
    dup.plate_position = self.plate_position;
    dup.purchase_amount = self.purchase_amount;
    dup.purchase_date = self.purchase_date;
    dup.source = self.source;
    
    dup.bureauPrecancel = self.bureauPrecancel;
    dup.cachet = self.cachet;
    dup.cancelQuality = self.cancelQuality;
    dup.centering = self.centering;
    dup.dealer = self.dealer;
    dup.format = self.format;
    dup.gpCatalog = self.gpCatalog;
    dup.grade = self.grade;
    dup.gumCondition = self.gumCondition;
    dup.hinged = self.hinged;
    dup.localPrecancel = self.localPrecancel;
    dup.location = self.location;
    dup.lot = self.lot;
    dup.mount = self.mount;
    dup.perfin = self.perfin;
    dup.soundness = self.soundness;
    
    // Stamp number must be obtained from the defaults.
    NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Stamp"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetch setPredicate:predicate];
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    if ([results count] == 1) {
        Stamp * defaults = results[0];
        
        NSString * stampNumber = defaults.gp_stamp_number;
        dup.gp_stamp_number = stampNumber;
        
        // Increment the count in defaults for the next stamp to be created.
        NSInteger stampNumInc = [stampNumber integerValue] + 1;
        defaults.gp_stamp_number = [NSString stringWithFormat:@"%ld", (long)stampNumInc];
    }
    
    return dup;
}

@end
