//
//  Cachet.m
//  GonePostal
//
//  Created by Travis Gruber on 6/5/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "Cachet.h"
#import "CachetCatalogName.h"
#import "CachetMakerName.h"
#import "GPCatalog.h"
#import "GPSalesGroup.h"
#import "Stamp.h"
#import "Valuation.h"

@implementation Cachet

- (Cachet *) duplicate {
    Cachet * copy = [NSEntityDescription insertNewObjectForEntityForName:@"Cachet" inManagedObjectContext:self.managedObjectContext];
    
    copy.gp_cachet_number = self.gp_cachet_number;
    copy.cachet_description = self.cachet_description;
    copy.cachet_picture = self.cachet_picture;
    copy.cachet_type = self.cachet_type;
    copy.color = self.color;
    copy.design_description = self.design_description;
    copy.external_catalog_number = self.external_catalog_number;
    copy.first_cachet = self.first_cachet;
    copy.modifiedByUser = self.modifiedByUser;
    
    copy.alternate_picture_1 = self.alternate_picture_1;
    copy.alternate_picture_2 = self.alternate_picture_2;
    copy.alternate_picture_3 = self.alternate_picture_3;
    copy.alternate_picture_4 = self.alternate_picture_4;
    copy.alternate_picture_5 = self.alternate_picture_5;
    copy.alternate_picture_6 = self.alternate_picture_6;
    
    copy.cachetCatalog = self.cachetCatalog;
    copy.cachetMakerName = self.cachetMakerName;
    copy.gpCatalog = self.gpCatalog;
    copy.salesGroup = self.salesGroup;
    
    return copy;
}

@end
