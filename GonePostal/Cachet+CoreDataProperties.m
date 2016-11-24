//
//  Cachet+CoreDataProperties.m
//  GonePostal
//
//  Created by Travis Gruber on 11/14/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "Cachet+CoreDataProperties.h"

@implementation Cachet (CoreDataProperties)

+ (NSFetchRequest<Cachet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"Cachet"];
}

@dynamic alternate_picture_1;
@dynamic alternate_picture_2;
@dynamic alternate_picture_3;
@dynamic alternate_picture_4;
@dynamic alternate_picture_5;
@dynamic alternate_picture_6;
@dynamic cachet_description;
@dynamic cachet_picture;
@dynamic cachet_type;
@dynamic color;
@dynamic design_description;
@dynamic external_catalog_number;
@dynamic first_cachet;
@dynamic gp_cachet_number;
@dynamic modifiedByUser;
@dynamic cachetCatalog;
@dynamic cachetMakerName;
@dynamic gpCatalog;
@dynamic salesGroup;
@dynamic stamps;
@dynamic values;
@dynamic gpCatalogSet;

@end
