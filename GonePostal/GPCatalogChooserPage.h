//
//  GPCatalogChooserPage.h
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StoredSearch.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "LooksLike.h"

@interface GPCatalogChooserPage : NSViewController <NSTableViewDelegate>

@property (strong, nonatomic) LooksLike * selectedLooksLike;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) GPCatalog * selectedGPCatalog;

@property (strong, nonatomic) NSArray * gpCatalogSortDescriptors;
@property (strong, nonatomic) NSArray * customSearchSortDescriptors;

@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFilterSearch * filterSearchController;

@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * filtersPredicate;

@property (strong, nonatomic) IBOutlet NSArrayController * gpCatalogController;

@property (strong, nonatomic) NSPredicate * currSearch;
@property (strong, nonatomic) StoredSearch * currCustomSearch;

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate;

@end
