//
//  GPLocatorPage.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLocatorPage.h"
#import "GonePostal-Swift.h"

@interface GPLocatorPage ()
@property (strong, nonatomic) GPDocument * doc;
@end

@implementation GPLocatorPage

// Update the current search based on the three saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:2];
    
    if (self.countrySearchController.predicate != nil) {
        [predicateArray addObject:self.countrySearchController.predicate];
    }
    
    if (self.sectionSearchController.predicate != nil) {
        [predicateArray addObject:self.sectionSearchController.predicate];
    }
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.assistedSearch.predicate = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    [self.doc saveInPlace];
    
    // Refetch the LooksLike Data.
    [self queryLooksLike];
}

- (id)initWithAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate {
    self = [super initWithNibName:@"GPLocatorPage" bundle:nil];
    if (self) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_lookslike_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = _doc.managedObjectContext;
        
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:NO];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:NO];
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    
    // Place the AssistedSearch views into panels which will be launched as sheets.
    self.countrySearchController.panel = [[NSPanel alloc] initWithContentRect:self.countrySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countrySearchController.panel setContentView:self.countrySearchController.view];
    
    self.sectionSearchController.panel = [[NSPanel alloc] initWithContentRect:self.sectionSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionSearchController.panel setContentView:self.sectionSearchController.view];

    [self queryLooksLike];
}

- (void)queryLooksLike {
    [self.looksLikeController setFetchPredicate:self.assistedSearch.predicate];
    [self.looksLikeController fetch:self];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    [self.view.window beginSheet:self.countrySearchController.panel completionHandler:^(NSModalResponse returnCode) {
        [self updateCurrentSearch];
        [self.view.window endSheet:self.countrySearchController.panel];
    }];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    [self.view.window beginSheet:self.sectionSearchController.panel completionHandler:^(NSModalResponse returnCode) {
        [self updateCurrentSearch];
        [self.view.window endSheet:self.sectionSearchController.panel];
    }];
}

@end
