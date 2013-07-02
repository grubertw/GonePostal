//
//  GPCatalog+Duplicate.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalog+Duplicate.h"
#import "AlternateCatalog.h"
#import "AlternateCatalogName.h"
#import "PlateUsage.h"
#import "PlateNumber.h"
#import "PlatePosition.h"

@implementation GPCatalog (Duplicate)

- (GPCatalog *)duplicateFromThis {
    GPCatalog * duplicate = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    duplicate.gp_catalog_number = self.gp_catalog_number;
    duplicate.majorVariety = self.majorVariety;
    
    duplicate.always_display = self.always_display;
    duplicate.color = self.color;
    duplicate.color_error = self.color_error;
    duplicate.color_variety = self.color_variety;
    duplicate.date_documented_first_use = self.date_documented_first_use;
    duplicate.date_documented_first_use_exact = self.date_documented_first_use_exact;
    duplicate.date_issued = self.date_issued;
    duplicate.date_issued_exact = self.date_issued_exact;
    duplicate.denomination = self.denomination;
    duplicate.design_measurement = self.design_measurement;
    duplicate.designers = self.designers;
    duplicate.engravers = self.engravers;
    duplicate.gp_description = self.gp_description;
    duplicate.gum = self.gum;
    duplicate.gum_variety = self.gum_variety;
    duplicate.hidden = self.hidden;
    duplicate.is_custom = self.is_custom;
    duplicate.issue_location = self.issue_location;
    duplicate.issue_name = self.issue_name;
    duplicate.long_description = self.long_description;
    duplicate.multiple_transfer = self.multiple_transfer;
    duplicate.number_of_panes = self.number_of_panes;
    duplicate.number_of_plates = self.number_of_plates;
    duplicate.number_of_plates_used = self.number_of_plates_used;
    duplicate.other_error = self.other_error;
    duplicate.pane_size = self.pane_size;
    duplicate.paper_color = self.paper_color;
    duplicate.paper_type = self.paper_type;
    duplicate.perf_error = self.perf_error;
    duplicate.perforation = self.perforation;
    duplicate.perforation_type = self.perforation_type;
    duplicate.plate_block_quantity = self.plate_block_quantity;
    duplicate.plate_error = self.plate_error;
    duplicate.plate_size = self.plate_size;
    duplicate.plate_variation = self.plate_variation;
    duplicate.plate_variation_type = self.plate_variation_type;
    duplicate.plated = self.plated;
    duplicate.press = self.press;
    duplicate.print = self.print;
    duplicate.print_variety = self.print_variety;
    duplicate.printer = self.printer;
    duplicate.quantity_ordered = self.quantity_ordered;
    duplicate.quantity_printed = self.quantity_printed;
    duplicate.quantity_sold = self.quantity_sold;
    duplicate.series = self.series;
    duplicate.surcharge_type = self.surcharge_type;
    duplicate.surcharged = self.surcharged;
    duplicate.tag = self.tag;
    duplicate.tag_error = self.tag_error;
    duplicate.tag_variety = self.tag_variety;
    duplicate.variety_description = self.variety_description;
    duplicate.variety_type = self.variety_type;
    duplicate.very_rare = self.very_rare;
    duplicate.watermark = self.watermark;
    duplicate.watermark_error = self.watermark_error;
    duplicate.watermark_variation = self.watermark_variation;
    
    duplicate.catalogGroup = self.catalogGroup;
    duplicate.country = self.country;
    duplicate.defaultCatalogName = self.defaultCatalogName;
    duplicate.formatType = self.formatType;
    duplicate.subvarietyType = self.subvarietyType;

    // Also duplicate the first (default) alternate catalog row
    AlternateCatalog * defaultAltCatalog;
    for (AlternateCatalog * ac in self.alternateCatalogs) {
        if ([ac.alternateCatalogName.alternate_catalog_name isEqualToString:self.defaultCatalogName.alternate_catalog_name]) {
            defaultAltCatalog = ac;
        }
        break;
    }
    
    AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:self.managedObjectContext];
    altCatalog.alternateCatalogName = defaultAltCatalog.alternateCatalogName;
    altCatalog.alternateCatalogGroup = defaultAltCatalog.alternateCatalogGroup;
    altCatalog.alternate_catalog_number = defaultAltCatalog.alternate_catalog_number;
    // Add to new entry.
    [duplicate addAlternateCatalogsObject:altCatalog];
    
    return duplicate;
}

- (void)copyPlateInfoIntoTarget:(GPCatalog *)target {
    for (PlateUsage *pu in self.plateUsage) {
        PlateUsage *puCopy = [NSEntityDescription insertNewObjectForEntityForName:@"PlateUsage" inManagedObjectContext:self.managedObjectContext];
        
        puCopy.plate_number = pu.plate_number;
        puCopy.plate_usage_name = pu.plate_usage_name;
        puCopy.usage_color = pu.usage_color;
        [puCopy addPlatePositions:pu.platePositions];
        
        [target addPlateUsageObject:puCopy];
    }
    
    for (PlateNumber *pn in self.plateNumbers) {
        PlateNumber *pnCopy = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
        
        pnCopy.combination_unknown = pn.combination_unknown;
        pnCopy.imprint_1 = pn.imprint_1;
        pnCopy.imprint_2 = pn.imprint_2;
        pnCopy.marking = pn.marking;
        pnCopy.max_percentage = pn.max_percentage;
        pnCopy.number_of_stamps = pn.number_of_stamps;
        pnCopy.plate1 = pn.plate1;
        pnCopy.plate2 = pn.plate2;
        pnCopy.plate3 = pn.plate3;
        pnCopy.plate4 = pn.plate4;
        pnCopy.plate5 = pn.plate5;
        pnCopy.plate6 = pn.plate6;
        pnCopy.plate7 = pn.plate7;
        pnCopy.plate8 = pn.plate8;
        pnCopy.very_rare = pn.very_rare;
        
        [target addPlateNumbersObject:pnCopy];
    }
}

@end
