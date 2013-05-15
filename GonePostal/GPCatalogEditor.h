//
//  GPCatalogEditor.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "GPCatalogSet.h"
#import "GPSetPopoverController.h"
#import "GPLooksLikePopoverController.h"
#import "Topic.h"
#import "StoredSearch.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "GPSubvarietySearch.h"

@interface GPCatalogEditor : NSWindowController <NSTableViewDelegate, NSTextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogEntriesSortDescriptors;
@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogNamesSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogSetsSortDescriptors;
@property (strong, nonatomic) NSArray * plateUsageSortDescriptors;
@property (strong, nonatomic) NSArray * plateNumberSortDescriptors;
@property (strong, nonatomic) NSArray * cachetSortDescriptors;
@property (strong, nonatomic) NSArray * looksLikeSortDescriptors;
@property (strong, nonatomic) NSArray * precancelsSortDescriptors;
@property (strong, nonatomic) NSArray * cancelationsSortDescriptors;
@property (strong, nonatomic) NSArray * topicsSortDescriptors;
@property (strong, nonatomic) NSArray * identificationPicturesSortDescriptors;
@property (strong, nonatomic) NSArray * subvarietyTypesSortDescriptors;
@property (strong, nonatomic) NSArray * customSearchSortDescriptors;

@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * filtersPredicate;

@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFilterSearch * filterSearchController;
@property (strong, nonatomic) GPSubvarietySearch * subvarietySearchController;

@property (strong, nonatomic) NSPredicate * currSearch;
@property (strong, nonatomic) StoredSearch * currCustomSearch;

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate;

// If not null, then user is viewing subvarieties.
@property (strong, nonatomic) GPCatalog * currMajorVariety;

- (void)queryGPCatalog;
- (void)querySubvarieties;

@end
