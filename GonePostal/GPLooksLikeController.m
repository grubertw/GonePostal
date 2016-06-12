//
//  GPLooksLikeController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLooksLikeController.h"
#import "LooksLike.h"
#import "GPDocument.h"

@interface GPLooksLikeController ()
@property (strong, nonatomic) GPDocument * doc;
@property (nonatomic, copy) void (^updateSearch)(NSModalResponse rc);
@end

@implementation GPLooksLikeController

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
    self = [super initWithWindowNibName:@"GPLooksLikeController"];
    if (self) {
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_lookslike_number" ascending:YES];
        _looksLikeSortDescriptors = @[sort];
        
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

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Place the AssistedSearch views into panels which will be launched as sheets.
    self.countrySearchController.panel = [[NSPanel alloc] initWithContentRect:self.countrySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countrySearchController.panel setContentView:self.countrySearchController.view];
    
    self.sectionSearchController.panel = [[NSPanel alloc] initWithContentRect:self.sectionSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionSearchController.panel setContentView:self.sectionSearchController.view];
    
    [self queryLooksLike];
    
    GPLooksLikeController * __weak weakSelf = self;
    self.updateSearch = ^(NSModalResponse rc){
        [weakSelf updateCurrentSearch];
    };
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Edit Looks Like";
}

- (void)queryLooksLike {
    [self.looksLikeController setFetchPredicate:self.assistedSearch.predicate];
    [self.looksLikeController fetch:self];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    [self.window beginSheet:self.countrySearchController.panel completionHandler:self.updateSearch];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    [self.window beginSheet:self.sectionSearchController.panel completionHandler:self.updateSearch];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [self updateCurrentSearch];
}

- (IBAction)addLooksLike:(id)sender {
    [self.looksLikeController insert:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeLooksLike:(id)sender {
    [self.looksLikeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}


@end
