//
//  GPManualValueSummer.h
//  GonePostal
//
//  Created by Travis Gruber on 5/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Stamp.h"

@interface GPValuationCalculator : NSValueTransformer

/** Derive the value/price of the stamp from available database data.
 *
 * This function calulates the overall value of the stamp, recursing
 * into child stamps if this stamp is a composite.  If 
 * manual_value_overrides_catalog_value is set, then the manual value
 * is used, else, the catalog value is used.
 *
 */
- (float)valueOfStamp:(Stamp *)stamp;

/** Derive the catalog value of the stamp based on available Valuation entries
 *
 * This function employs the three-step process of calculating a stamp's
 * worth from the valuation data.  The valuation data is structured in
 * a mannor which can be evaluated as a decision tree.  Evaluation starts 
 * at the bottom of the tree (the Conditions), and works it's way upward.
 *
 */
+ (NSString *)deriveCatalogValueOfStamp:(Stamp *)stamp;

@end
