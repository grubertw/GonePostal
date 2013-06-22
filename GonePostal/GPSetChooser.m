//
//  GPSetChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 6/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSetChooser.h"
#import "GPDocument.h"
#import "GPCatalog.h"
#import "Stamp+CreateComposite.h"

@interface GPSetChooser ()
@property (strong, nonatomic) GPCollection * collection;
@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;

@property (strong, nonatomic) IBOutlet NSArrayController * catalogSetsController;
@property (strong, nonatomic) IBOutlet NSArrayController * catalogEntriesController;

@property (weak, nonatomic) IBOutlet NSButton * addAsCompositeCheckBox;
@property (weak, nonatomic) IBOutlet NSButton * onlyAddSelectedCheckBox;
@end

@implementation GPSetChooser

- (id)initWithGPCollection:(GPCollection *)collection andAssistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate {
    self = [super initWithWindowNibName:@"GPSetChooser"];
    if (self) {
        _managedObjectContext = collection.managedObjectContext;
        
        _collection = collection;
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        
        NSSortDescriptor *setSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _setSortDescriptors = @[setSort];
        
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        _catalogEntriesSortDescriptors = @[catalogNumberSort];
        
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
    
    [self querySets];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Add a catalog set to your collection.";
}

- (void)querySets {
    [self.catalogSetsController setFetchPredicate:self.assistedSearch.predicate];
    [self.catalogSetsController fetch:self];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.countrySearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.sectionSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [self updateCurrentSearch];
}

// Update the current search based on the saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:0];
    
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
    
    [self.document saveInPlace];
    
    // Refetch the sets based on new filter.
    [self querySets];
}

- (IBAction)selectAll:(id)sender {
    [self.catalogEntriesController setSelectedObjects:self.catalogEntriesController.arrangedObjects];
}

- (IBAction)addToCollection:(id)sender {
    NSMutableSet * stamps = [[NSMutableSet alloc] initWithCapacity:0];
    NSArray * entries;
    
    if ([self.onlyAddSelectedCheckBox state] == NSOnState) {
        entries = self.catalogEntriesController.selectedObjects;
    }
    else {
        entries = self.catalogEntriesController.arrangedObjects;
    }
    
    for (GPCatalog * entry in entries) {
        Stamp * stamp = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:self.managedObjectContext];
        
        stamp.gp_stamp_number = entry.gp_catalog_number;
        stamp.gpCatalog = entry;
        [stamps addObject:stamp];
    }

    
    if ([self.addAsCompositeCheckBox state] == NSOnState) {
        Stamp * composite = [Stamp createCompositeType:COMPOSITE_TYPE_SET fromSet:stamps];
        [self.collection addStampsObject:composite];
    }
    else {
        [self.collection addStamps:stamps];
    }

    [self.window performClose:sender];
}

@end
