//
//  GPSalesGroup.m
//  GonePostal
//
//  Created by Travis Gruber on 1/20/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPSalesGroup.h"
#import "Attachment.h"
#import "BureauPrecancel.h"
#import "Cachet+CoreDataClass.h"
#import "Cancelations.h"
#import "GPCatalog.h"
#import "GPCatalogGroup.h"
#import "GPCatalogSet+CoreDataClass.h"
#import "GPSalesGroupType.h"
#import "LocalPrecancel.h"
#import "LooksLike.h"
#import "Perfin.h"
#import "PlateNumber.h"
#import "Topic.h"


@implementation GPSalesGroup

@dynamic lastDateUpdated;
@dynamic name;
@dynamic productDescription;
@dynamic purchaseKey;
@dynamic salePrice;
@dynamic salesID;
@dynamic version;
@dynamic salesIDString;
@dynamic attachments;
@dynamic bureauPrecancels;
@dynamic cachets;
@dynamic cancelations;
@dynamic catalogEntries;
@dynamic catalogGroups;
@dynamic catalogSets;
@dynamic localPrecanels;
@dynamic looksLikes;
@dynamic perfinEntries;
@dynamic plateNumbers;
@dynamic topics;
@dynamic salesGroupType;

@end
