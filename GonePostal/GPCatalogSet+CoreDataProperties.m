//
//  GPCatalogSet+CoreDataProperties.m
//  GonePostal
//
//  Created by Travis Gruber on 11/20/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "GPCatalogSet+CoreDataProperties.h"

@implementation GPCatalogSet (CoreDataProperties)

+ (NSFetchRequest<GPCatalogSet *> *)fetchRequest {
	return [[NSFetchRequest alloc] initWithEntityName:@"GPCatalogSet"];
}

@dynamic gp_set_number;
@dynamic modifiedByUser;
@dynamic name;
@dynamic picture;
@dynamic cachets;
@dynamic catalogGroup;
@dynamic country;
@dynamic gpCatalogEntries;
@dynamic salesGroup;
@dynamic stamps;

@end
