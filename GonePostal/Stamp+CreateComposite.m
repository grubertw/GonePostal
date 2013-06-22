//
//  Stamp+CreateComposite.m
//  GonePostal
//
//  Created by Travis Gruber on 5/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp+CreateComposite.h"
#import "GPCatalog.h"
#import "Country.h"
#import "GPCatalogGroup.h"

const NSInteger COMPOSITE_TYPE_MULTI_QUANTITY               = 1;
const NSInteger COMPOSITE_TYPE_SET                          = 2;
const NSInteger COMPOSITE_TYPE_INTEGRAL                     = 3;

@implementation Stamp (CreateComposite)

// Create a multi-quantity composite from this stamp and then insert
// this stamp as a child, along with numChildren other items.
- (Stamp *)createCompositeFromThisContainingAmount:(NSInteger)numChildren {
    // First create the composite.
    Stamp * composite = [self duplicate];
    composite.parentType = @(COMPOSITE_TYPE_MULTI_QUANTITY);
    
    // Next create the children, minus this.
    for (NSInteger i=1; i <numChildren; i++) {
        Stamp * child = [self duplicate];
        
        // Establish the parent-child relationship.
        child.parent = composite;
        [composite addChildrenObject:child];
    }
    
    // Add this as a child to the composite.
    self.parent = composite;
    [composite addChildrenObject:self];
    
    return composite;
}

- (Stamp *)duplicate {
    Stamp * dup = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:self.managedObjectContext];
    
    dup.manual_value = self.manual_value;
    dup.purchase_amount = self.purchase_amount;
    dup.address_type = self.address_type;
    dup.alternate_picture_1 = self.alternate_picture_1;
    dup.alternate_picture_2 = self.alternate_picture_2;
    dup.alternate_picture_3 = self.alternate_picture_3;
    dup.alternate_picture_4 = self.alternate_picture_4;
    dup.alternate_picture_5 = self.alternate_picture_5;
    dup.alternate_picture_6 = self.alternate_picture_6;
    dup.cancelation_type = self.cancelation_type;
    dup.census_id = self.census_id;
    dup.certificates = self.certificates;
    dup.default_picture = self.default_picture;
    dup.faults = self.faults;
    dup.gp_stamp_number = self.gp_stamp_number;
    dup.history = self.history;
    dup.inprint_1 = self.inprint_1;
    dup.inprint_2 = self.inprint_2;
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
    dup.source = self.source;
    dup.mint_used = self.mint_used;
    dup.cancelation_date = self.cancelation_date;
    dup.purchase_date = self.purchase_date;
    
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
    dup.valuation = self.valuation;
    
    return dup;
}

// Create a composite list of stamps containing the passed-in arbitrary
// set of stamps.
// Use the 'type' field to controll whether the set is an integral
// type (in which the parent cannot be deleted if it has children),
// or a set type (in which the parent CAN be deleted).
+ (Stamp *)createCompositeType:(NSInteger)type fromSet:(NSSet *)set {
    if (!set || [set count] == 0) return nil;
    
    // Sort the set to find out the lowest GPID.
    NSSortDescriptor * stampSort = [[NSSortDescriptor alloc] initWithKey:@"gp_stamp_number" ascending:NO];
    NSArray * sortDescs = @[stampSort];
    
    NSArray * sortedSet = [set sortedArrayUsingDescriptors:sortDescs];
    Stamp * representingStamp = sortedSet[0];
    
    NSString * repGPID = representingStamp.gp_stamp_number;
    Country * country = representingStamp.gpCatalog.country;
    GPCatalogGroup * section = representingStamp.gpCatalog.catalogGroup;
    
    // Create the composite.
    Stamp * composite = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:[[set anyObject] managedObjectContext]];
    composite.gp_stamp_number = repGPID;
    composite.parentType = @(type);
    
    // Create a dummy GPCatalog entry for sorting by country and section.
    GPCatalog * dummyEntry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:composite.managedObjectContext];
    dummyEntry.gp_catalog_number = repGPID;
    dummyEntry.country = country;
    dummyEntry.catalogGroup = section;
    dummyEntry.composite_placeholder = @(YES);
    composite.gpCatalog = dummyEntry;
    
    // Create a child for each stamp in the set.
    for (Stamp * child in set) {
        // Establish the parent-child relationship.
        child.parent = composite;
        [composite addChildrenObject:child];
    }
    
    return composite;
}

@end
