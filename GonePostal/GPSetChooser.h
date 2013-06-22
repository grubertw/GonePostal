//
//  GPSetChooser.h
//  GonePostal
//
//  Created by Travis Gruber on 6/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPCollection.h"
#import "StoredSearch.h"

@interface GPSetChooser : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * setSortDescriptors;
@property (strong, nonatomic) NSArray * catalogEntriesSortDescriptors;

@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;

- (id)initWithGPCollection:(GPCollection *)collection andAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate;

@end
