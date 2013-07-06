//
//  Stamp+CreateComposite.m
//  GonePostal
//
//  Created by Travis Gruber on 5/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp+CreateComposite.h"
#import "Stamp+Duplicate.h"
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
