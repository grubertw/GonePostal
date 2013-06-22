//
//  Stamp+CreateComposite.h
//  GonePostal
//
//  Created by Travis Gruber on 5/30/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp.h"

extern const NSInteger COMPOSITE_TYPE_MULTI_QUANTITY;
extern const NSInteger COMPOSITE_TYPE_SET;
extern const NSInteger COMPOSITE_TYPE_INTEGRAL;

@interface Stamp (CreateComposite)

// Create a multi-quantity composite from this stamp and then insert
// this stamp as a child, along with numChildren other items.
- (Stamp *)createCompositeFromThisContainingAmount:(NSInteger)numChildren;

// Create a composite list of stamps containing the passed-in arbitrary
// set of stamps.
// Use the 'type' field to controll whether the set is an integral
// type (in which the parent cannot be deleted if it has children),
// or a set type (in which the parent CAN be deleted).
+ (Stamp *)createCompositeType:(NSInteger)type fromSet:(NSSet *)set;

@end
