//
//  GPCatalog+Duplicate.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalog.h"

@interface GPCatalog (Duplicate)

// Dupicates self, adding to the same managed object context.
// NOTE: This method does NOT save the context.
- (GPCatalog *)duplicateFromThis;

- (void)copyPlateInfoIntoTarget:(GPCatalog *)target;
- (void)copyBureauPrecancelInfoIntoTarget:(GPCatalog *)target;

@end
