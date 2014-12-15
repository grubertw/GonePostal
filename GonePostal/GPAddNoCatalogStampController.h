//
//  GPAddNoCatalogStampController.h
//  GonePostal
//
//  Created by Travis Gruber on 12/12/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCollection.h"

@interface GPAddNoCatalogStampController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * formatSortDescriptors;
@property (strong, nonatomic) NSArray * centeringSortDescriptors;
@property (strong, nonatomic) NSArray * soundnessSortDescriptors;
@property (strong, nonatomic) NSArray * gradeSortDescriptors;
@property (strong, nonatomic) NSArray * cancelQualitySortDescriptors;
@property (strong, nonatomic) NSArray * gumConditionSortDescriptors;
@property (strong, nonatomic) NSArray * hingedSortDescriptors;
@property (strong, nonatomic) NSArray * dealerSortDescriptors;
@property (strong, nonatomic) NSArray * lotSortDescriptors;
@property (strong, nonatomic) NSArray * locationSortDescriptors;
@property (strong, nonatomic) NSArray * mountSortDescriptors;

- (id)initWithCollection:(GPCollection *)stampCollection;

@end
