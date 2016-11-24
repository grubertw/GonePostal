//
//  GPCatalogEditor.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "GPCatalogSet+CoreDataClass.h"
#import "GPSetPopoverController.h"
#import "GPLooksLikePopoverController.h"
#import "Topic.h"
#import "StoredSearch.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "GPSubvarietySearch.h"
#import "StampFormat.h"

@interface GPCatalogEditor : NSWindowController <NSTableViewDelegate, NSTextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogEntriesSortDescriptors;
@property (strong, nonatomic) NSArray * subvarietySortDescriptors;

@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * stampFormatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogNamesSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogSetsSortDescriptors;
@property (strong, nonatomic) NSArray * numberOfStampsInPlateSortDescriptors;
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
@property (strong, nonatomic) NSArray * attachmentsSortDescriptors;
@property (strong, nonatomic) NSArray * subjectsSortDescriptors;
@property (strong, nonatomic) NSArray * priceListSortDescriptors;
@property (strong, nonatomic) NSArray * valuationPerFormatSortDescriptors;
@property (strong, nonatomic) NSArray * salesGroupSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogDateSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogPeopleSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogPlateSizeSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogQuantitySortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogAlbumSizeSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogEntriesController;

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

// Used when adding GPCatalog entries to a GPCatalogSet.
@property (strong, nonatomic) GPCatalogSet * selectedSet;

// Used when adding allowed stamp formats to a GPCatalog entrey.
@property (strong, nonatomic) StampFormat * allowedStampFormatToAdd;

- (void)loadSubvarieties:(GPCatalog *)majorVariety;

@end
