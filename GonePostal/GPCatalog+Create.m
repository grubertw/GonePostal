//
//  GPCatalog+Create.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalog+Create.h"
#import "GPCatalog+Duplicate.h"
#import "AlternateCatalog.h"
#import "GPCatalogAlbumSize.h"
#import "GPCatalogDate.h"
#import "GPCatalogPeople.h"
#import "GPCatalogQuantity.h"
#import "GPPlateSize.h"

@implementation GPCatalog (Create)

+ (GPCatalog *)createFromDefaultsUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Error creating entry %@, %@", error, [error userInfo]);
	    abort();
    }
    
    // The entry is created, no matter what.  If defautls are found,
    // they are copied into the entry.
    GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:managedObjectContext];
    
    if (results.count == 1) {
        GPCatalog * defaults = [results objectAtIndex:0];
        
        entry.gp_catalog_number = defaults.gp_catalog_number;
        
        entry.always_display = defaults.always_display;
        entry.color = defaults.color;
        entry.color_error = defaults.color_error;
        entry.color_variety = defaults.color_variety;
        entry.date_documented_first_use = defaults.date_documented_first_use;
        entry.date_documented_first_use_exact = defaults.date_documented_first_use_exact;
        entry.date_issued = defaults.date_issued;
        entry.date_issued_exact = defaults.date_issued_exact;
        entry.denomination = defaults.denomination;
        entry.design_measurement = defaults.design_measurement;
        entry.designers = defaults.designers;
        entry.engravers = defaults.engravers;
        entry.foldable = defaults.foldable;
        entry.gp_description = defaults.gp_description;
        entry.gum = defaults.gum;
        entry.gum_variety = defaults.gum_variety;
        entry.hidden = defaults.hidden;
        entry.is_custom = defaults.is_custom;
        entry.issue_location = defaults.issue_location;
        entry.issue_name = defaults.issue_name;
        entry.long_description = defaults.long_description;
        entry.multiple_transfer = defaults.multiple_transfer;
        entry.number_of_panes = defaults.number_of_panes;
        entry.number_of_plates = defaults.number_of_plates;
        entry.number_of_plates_used = defaults.number_of_plates_used;
        entry.other_error = defaults.other_error;
        entry.packaging = defaults.packaging;
        entry.pane_size = defaults.pane_size;
        entry.paper_color = defaults.paper_color;
        entry.paper_type = defaults.paper_type;
        entry.perf_error = defaults.perf_error;
        entry.perforation = defaults.perforation;
        entry.perforation_type = defaults.perforation_type;
        entry.plate_block_quantity = defaults.plate_block_quantity;
        entry.plate_error = defaults.plate_error;
        entry.plate_size = defaults.plate_size;
        entry.plate_variation = defaults.plate_variation;
        entry.plate_variation_type = defaults.plate_variation_type;
        entry.plated = defaults.plated;
        entry.press = defaults.press;
        entry.print = defaults.print;
        entry.print_variety = defaults.print_variety;
        entry.printer = defaults.printer;
        entry.printing_on_back = defaults.printing_on_back;
        entry.quantity_ordered = defaults.quantity_ordered;
        entry.quantity_printed = defaults.quantity_printed;
        entry.quantity_sold = defaults.quantity_sold;
        entry.series = defaults.series;
        entry.surcharge_type = defaults.surcharge_type;
        entry.surcharged = defaults.surcharged;
        entry.tag = defaults.tag;
        entry.tag_error = defaults.tag_error;
        entry.tag_variety = defaults.tag_variety;
        entry.variety_description = defaults.variety_description;
        entry.variety_type = defaults.variety_type;
        entry.very_rare = defaults.very_rare;
        entry.watermark = defaults.watermark;
        entry.watermark_error = defaults.watermark_error;
        entry.watermark_variation = defaults.watermark_variation;
        
        entry.catalogGroup = defaults.catalogGroup;
        entry.country = defaults.country;
        entry.defaultCatalogName = defaults.defaultCatalogName;
        [entry addAllowedStampFormats:defaults.allowedStampFormats];
        
        AlternateCatalog * defaultAltCatalog;
        for (AlternateCatalog * ac in defaults.alternateCatalogs) {
            defaultAltCatalog = ac;
            break;
        }
        
        // Create an alternate catalog entry for this GPCatalog based on defaults.
        AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:managedObjectContext];
        altCatalog.alternateCatalogName = defaultAltCatalog.alternateCatalogName;
        altCatalog.alternateCatalogGroup = defaultAltCatalog.alternateCatalogGroup;
        // Add to new entry.
        [entry addAlternateCatalogsObject:altCatalog];
        
        // Copy the ablum sizes.
        for (GPCatalogAlbumSize * albumSize in defaults.albumSizes) {
            GPCatalogAlbumSize * newAlbumSize = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogAlbumSize" inManagedObjectContext:defaults.managedObjectContext];
            newAlbumSize.albumHeight = albumSize.albumHeight;
            newAlbumSize.albumWidth = albumSize.albumWidth;
            newAlbumSize.modifiedByUser = albumSize.modifiedByUser;
            newAlbumSize.mountSize = albumSize.mountSize;
            newAlbumSize.format = albumSize.format;
            [entry addAlbumSizesObject:newAlbumSize];
        }
        
        // Copy catalog dates.
        for (GPCatalogDate * date in defaults.dates) {
            GPCatalogDate * newDate = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogDate" inManagedObjectContext:defaults.managedObjectContext];
            newDate.catalogDate = date.catalogDate;
            newDate.dayExact = date.dayExact;
            newDate.details = date.details;
            newDate.modifiedByUser = date.modifiedByUser;
            newDate.monthExact = date.monthExact;
            newDate.dateType = date.dateType;
            [entry addDatesObject:newDate];
        }
        
        // Copy people.
        for (GPCatalogPeople * person in defaults.people) {
            GPCatalogPeople * newPerson = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogPeople" inManagedObjectContext:defaults.managedObjectContext];
            newPerson.details = person.details;
            newPerson.modifiedByUser = person.modifiedByUser;
            newPerson.personName = person.personName;
            newPerson.peopleType = person.peopleType;
            [entry addPeopleObject:newPerson];
        }
        
        // Copy quantities.
        for (GPCatalogQuantity * quant in defaults.quantities) {
            GPCatalogQuantity * newQuant = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogQuantity" inManagedObjectContext:defaults.managedObjectContext];
            newQuant.details = quant.details;
            newQuant.modifiedByUser = quant.modifiedByUser;
            newQuant.quantity = quant.quantity;
            newQuant.quantityType = quant.quantityType;
            [entry addQuantitiesObject:newQuant];
        }
        
        // Copy Plate Sizes.
        for (GPPlateSize * ps in defaults.plateSizes) {
            GPPlateSize * newPS = [NSEntityDescription insertNewObjectForEntityForName:@"GPPlateSize" inManagedObjectContext:defaults.managedObjectContext];
            newPS.coilLength = ps.coilLength;
            newPS.details = ps.details;
            newPS.modifiedByUser = ps.modifiedByUser;
            newPS.numberOfPanes = ps.numberOfPanes;
            newPS.paneHeight = ps.paneHeight;
            newPS.paneSize = ps.paneSize;
            newPS.paneWidth = ps.paneWidth;
            newPS.plateSize = ps.plateSize;
            newPS.plateSizeType = ps.plateSizeType;
            [entry addPlateSizesObject:newPS];
        }
    }
    
    return entry;
}

+ (GPCatalog *)createFromMajorVariety:(GPCatalog *)theMajorVariety {
    
    // Duplicate the major variety first.
    GPCatalog * subvariety = [theMajorVariety duplicateFromThis];
    
    // Set the majorVariety reference of the subvariety.
    subvariety.majorVariety = theMajorVariety;
    
    // Set this subvariety into the major variety's set of subvarieties.
    [theMajorVariety addSubvarietiesObject:subvariety];
    theMajorVariety.has_subvarieties = [NSNumber numberWithBool:YES];
    
    return subvariety;
}

@end
