//
//  GPSalesGroup.m
//  GonePostal
//
//  Created by Travis Gruber on 1/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPSalesGroup.h"
#import "Attachment.h"
#import "BureauPrecancel.h"
#import "Cachet.h"
#import "Cancelations.h"
#import "GPCatalog.h"
#import "GPCatalogGroup.h"
#import "GPCatalogSet.h"
#import "LocalPrecancel.h"
#import "LooksLike.h"
#import "Perfin.h"
#import "PlateNumber.h"
#import "Topic.h"


@implementation GPSalesGroup

@dynamic lastDateUpdated;
@dynamic name;
@dynamic purchaseKey;
@dynamic salePrice;
@dynamic salesID;
@dynamic version;
@dynamic productDescription;
@dynamic attachments;
@dynamic cachets;
@dynamic catalogEntries;
@dynamic catalogGroups;
@dynamic catalogSets;
@dynamic perfinEntries;
@dynamic plateNumbers;
@dynamic bureauPrecancels;
@dynamic cancelations;
@dynamic topics;
@dynamic localPrecanels;
@dynamic looksLikes;

@end
