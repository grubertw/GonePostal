//
//  GPCatalogPictureSelector.h
//  GonePostal
//
//  Created by Travis Gruber on 6/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StoredSearch.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFilterSearch.h"
#import "GPSubvarietySearch.h"
#import "GPCatalog.h"
#import "LooksLike.h"

@interface GPCatalogPictureSelector : NSWindowController <NSTableViewDelegate, NSTextFieldDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogSortDescriptors;

@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * filtersPredicate;

@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFilterSearch * filterSearchController;
@property (strong, nonatomic) GPSubvarietySearch * subvarietySearchController;

@property (strong, nonatomic) GPCatalog * targetGPCatalog;
@property (strong, nonatomic) LooksLike * targetLooksLike;

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate filterSearch:(NSPredicate *)filtersPredicate targetAttributeName:(NSString *)attributeName selectingPicture:(BOOL)selectingPicture;

// If not null, then user is viewing subvarieties.
@property (strong, nonatomic) GPCatalog * currMajorVariety;

@end
