//
//  GPManualValueSummer.m
//  GonePostal
//
//  Created by Travis Gruber on 5/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPValuationCalulator.h"
#import "GPDocument.h"
#import "GPCollection.h"
#import "Stamp.h"
#import "PriceList.h"

@implementation GPValuationCalulator

+ (Class)transformedValueClass { return [NSNumber class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    float netWorth = 0.0;
    
    if ([value isKindOfClass:[GPCollection class]]) {
        GPCollection * collection = (GPCollection *)value;
        
        for (Stamp * stamp in collection.stamps) {
            netWorth += [self valueOfStamp:stamp];
        }
    }
    else if ([value isKindOfClass:[Stamp class]]) {
        Stamp * stamp = (Stamp *)value;
        netWorth = [self valueOfStamp:stamp];
    }
    
    NSNumber * rc = @(netWorth);
    return rc;
}

/** Derive the value/price of the stamp from available database data.
 *
 * This function calulates the overall value of the stamp, recursing
 * into child stamps if this stamp is a composite.  If
 * manual_value_overrides_catalog_value is set, then the manual value
 * is used, else, the catalog value is used.
 *
 */
- (float)valueOfStamp:(Stamp *)stamp {
    float worth = 0;
    
    if ([stamp.children count] > 0) {
        for (Stamp * child in stamp.children) {
            if ([child.manual_value_overrides_catalog_value isEqualToNumber:@(YES)])
                worth += [child.manual_value floatValue];
            else 
                worth += [child.catalog_value floatValue];
        }
    }
    else {
        if ([stamp.manual_value_overrides_catalog_value isEqualToNumber:@(YES)])
            worth = [stamp.manual_value floatValue];
        else
            worth = [stamp.catalog_value floatValue];
    }
    
    return worth;
}

/** Derive the catalog value of the stamp based on available Valuation entries
 *
 * This function employs the three-step process of calculating a stamp's
 * worth from the valuation data.  The valuation data is structured in
 * a mannor which can be evaluated as a decision tree.  Evaluation starts
 * at the bottom of the tree (the Conditions), and works it's way upward.
 *
 */
- (float)deriveCatalogValueOfStamp:(Stamp *)stamp {
    float catalogValue = 0;
    
    // First determine the PriceList to use.
    // Get this from the containing collection.
    // NOTE: there may be multiple collections, but only one
    // 'normal' collection, which isn't a want or sell list.
    GPCollection * containingCollection;
    for (GPCollection * collection in stamp.collections) {
        if ([collection.type isEqualToNumber:@(GP_COLLECTION_TYPE_NORMAL)]) {
            containingCollection = collection;
            break;
        }
    }
    
    // Proceed no further if the containing collection cannot be found.
    if (!containingCollection) return 0;
    
    // Proceed no further if no PriceList can be found.
    PriceList * priceList = containingCollection.assingedPriceList;
    if (!priceList) return 0;
    
    //
    // Evaluate level three (Condition) first.
    // Get all level3 valuation nodes for this PriceList and GPCatalog.
    // Each condition type has a priority.  The highest priority condition
    // is evaluated first.  If there is an exact match between the valuation
    // condtion and the stamp condition, then this valuation node is used,
    // elsewise, the next higest priority condition is evaluated.  If there
    // are no matches for any of the conditions at level 3, then evaluation
    // continues upard to level 2.
    //
    
    //
    // Valuation nodes at level 2 are "object" nodes
    // (a.k.a. Cachet/PlateNumber ect).
    // Since a stamp is unlikely to be/have a cachet or be part of a plate
    // block, a strict priority scheme cannot be used.  Instead, a liner
    // approch is taken.  If the stamp has a cachet, check for catchet
    // valuation nodes.  If none exist, fall up to level 1.  If the stamp
    // has a plate combination (has plate numbers assigned), obtain the
    // PlateNumber valuation nodes. ect. with bureau precancel.
    //
    
    //
    // Valuation nodes at level 1 are StampFormat nodes.
    // Try to find a match in the Valuation data for the stamp's current
    // stamp format.  If a match is found, set the catalog_value of the
    // stamp to the price indicated in the valuation node.
    //
    
    
    
    
    // If no matching data can be found at any level, then catalogValue
    // returns 0 and the value is not set in the stamp.
    
    return catalogValue;
}

@end
