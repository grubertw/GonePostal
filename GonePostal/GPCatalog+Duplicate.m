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

@implementation GPCatalog (Duplicate)

- (GPCatalog *)duplicateFromThis {
    GPCatalog * duplicate = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    duplicate.gp_catalog_number = self.gp_catalog_number;
    
    duplicate.always_display = self.always_display;
    duplicate.background_information = self.background_information;
    duplicate.color = self.color;
    duplicate.color_error = self.color_error;
    duplicate.color_variety = self.color_variety;
    duplicate.date_issued = self.date_issued;
    duplicate.denomination = self.denomination;
    duplicate.design_measurement = self.design_measurement;
    duplicate.gp_description = self.gp_description;
    duplicate.gum = self.gum;
    duplicate.gum_variety = self.gum_variety;
    duplicate.hidden = self.hidden;
    duplicate.identification_notes = self.identification_notes;
    duplicate.is_custom = self.is_custom;
    duplicate.issue_location = self.issue_location;
    duplicate.multiple_transfer = self.number_of_panes;
    duplicate.number_of_panes = self.number_of_panes;
    duplicate.other_error = self.other_error;
    duplicate.pane_size = self.pane_size;
    duplicate.paper_type = self.paper_type;
    duplicate.perf_error = self.perf_error;
    duplicate.perforation = self.perforation;
    duplicate.plate_block_quantity = self.plate_block_quantity;
    duplicate.plate_error = self.plate_error;
    duplicate.plate_size = self.plate_size;
    duplicate.plate_variation = self.plate_variation;
    duplicate.print = self.print;
    duplicate.print_variety = self.print_variety;
    duplicate.printer = self.printer;
    duplicate.quantity_printed = self.quantity_printed;
    duplicate.series = self.series;
    duplicate.tag = self.tag;
    duplicate.tag_error = self.tag_error;
    duplicate.tag_variety = self.tag_variety;
    duplicate.variety_description = self.variety_description;
    duplicate.variety_type = self.variety_type;
    duplicate.very_rare = self.very_rare;
    duplicate.watermark = self.watermark;
    duplicate.majorVariety = self.majorVariety;
    
    duplicate.catalogGroup = self.catalogGroup;
    duplicate.country = self.country;
    duplicate.defaultCatalogName = self.defaultCatalogName;
    duplicate.formatType = self.formatType;

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

@end
