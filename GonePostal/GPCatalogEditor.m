//
//  GPCatalogEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogEditor.h"
#import "GPDocument.h"
#import "GPAddToCatalogController.h"
#import "GPAddSubvariety.h"
#import "GPCatalog+Duplicate.h"
#import "GPCatalogSet.h"
#import "GPSetController.h"
#import "PlateUsage.h"
#import "PlateNumber.h"
#import "GPPlateUsageController.h"
#import "Cachet.h"
#import "LooksLike.h"
#import "GPLooksLikeController.h"
#import "BureauPrecancel.h"
#import "Cancelations.h"
#import "GPTopicsController.h"
#import "GPPicture.h"
#import "StoredSearch.h"
#import "Country.h"
#import "GPCatalogGroup.h"

static NSString * BASE_GP_CATALOG_QUERY = @"is_default==0 and majorVariety==nil";
static NSString * DEFAULT_GPCATALOG_QUERY = @"is_default==0 and majorVariety==nil and country.country_sort_id==0 and catalogGroup.group_number==1";

// Private members.
@interface GPCatalogEditor ()
@property (strong, nonatomic) StoredSearch * storedAssistedSearch;
@property (strong, nonatomic) NSPredicate * currentSearch;
@property (strong, nonatomic) NSPredicate * subvarietiesSearch;

@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * filtersPredicate;

- (void)initCurrentSearch;

- (void)parseAssistedSearch:(NSPredicate *)search parent:(NSPredicate *)parentSearch;
- (void)loadCountrySearchControllersFromPredicate;
- (void)loadSectionsSearchControllersFromPredicate;
- (void)loadFiltersSearchAttributesFromPredicate;

- (void)updateCurrentSearch;
@end

@implementation GPCatalogEditor

// Intialize the current GPCatalog search from the StoredSearch table.
- (void)initCurrentSearch {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"identifier==%ld", LAST_VIEWIED_GP_CATALOG_QUERY];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Fetch error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    if (results.count == 1) {
        // Initialize from the StoredSearch entry inside the database.
        // Hang onto a reference for future saving.
        self.storedAssistedSearch = [results objectAtIndex:0];
        self.currentSearch = self.storedAssistedSearch.predicate;
        
        // Parse the assisted search into three predicates.
        [self parseAssistedSearch:self.currentSearch parent:nil];
        
        // Load the country search controllers from the country predicate.
        [self loadCountrySearchControllersFromPredicate];
        
        // Load the sections search controllers from the section predicate.
        [self loadSectionsSearchControllersFromPredicate];
        
        // Set the filters private member variables.
        [self loadFiltersSearchAttributesFromPredicate];
    }
    else {
        // Create the initial search from the factory default constant.
        self.currentSearch = [NSPredicate predicateWithFormat:DEFAULT_GPCATALOG_QUERY];
        
        // First time create of the stored assisted search
        self.storedAssistedSearch = [NSEntityDescription insertNewObjectForEntityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
        self.storedAssistedSearch.predicate = self.currentSearch;
        self.storedAssistedSearch.identifier = [NSNumber numberWithInteger:LAST_VIEWIED_GP_CATALOG_QUERY];
    }

    // Fetch the GP Catalog Data.
    [self queryGPCatalog];
}

// Break the stored assisted search down into three predicates:
// country, section, and filter.
- (void)parseAssistedSearch:(NSPredicate *)search parent:(NSPredicate *)parentSearch {
    if ([search isMemberOfClass:[NSCompoundPredicate class]]) {
        // Break the compound predicate into it's component pieces.
        NSArray * subpreds = ((NSCompoundPredicate *)search).subpredicates;
        
        //NSLog(@"parseAssistedSearch found %ld subpredicates in compound predicate", subpreds.count);
        
        for (NSUInteger i=0; i<subpreds.count; i++) {
            NSPredicate * subPredicate = [subpreds objectAtIndex:i];
            
            // Recursivly call into this method to determine the comparison type.
            [self parseAssistedSearch:subPredicate parent:search];
        }
    }
    else if ([search isMemberOfClass:[NSComparisonPredicate class]]) {
        // Obtain the left expression to determine which of
        // the three preicate types this is.
        NSExpression * leftExpression = ((NSComparisonPredicate *)search).leftExpression;
        
        //NSLog(@"parseAssistedSearch found comparison predicate with leftExpression of type %ld", leftExpression.expressionType);
        
        if (leftExpression.expressionType == NSKeyPathExpressionType) {
            // Determine if the respresenting predicate needs to be this predicate
            // or the parent.
            NSPredicate * representingPredicate;
            if (   parentSearch == nil
                || [parentSearch isEqualTo:self.currentSearch])
                representingPredicate = search;
            else
                representingPredicate = parentSearch;
            
            //NSLog(@"  leftExpression keyPath is %@", leftExpression.keyPath);
            
            if ([leftExpression.keyPath isEqualToString:@"country.country_sort_id"]) {
                self.countriesPredicate = representingPredicate;
            }
            else if ([leftExpression.keyPath isEqualToString:@"catalogGroup.group_number"]) {
                self.sectionsPredicate = representingPredicate;
            }
            else if (   ![leftExpression.keyPath isEqualToString:@"is_default"]
                     && ![leftExpression.keyPath isEqualToString:@"majorVariety"]) {
                self.filtersPredicate = representingPredicate;
            }
        }
    }
}

// Parse the countryPredicate to find out the current countries
// used in the search.  Use this information, along with a fetch
// quary, to populate the country search controllers.
- (void)loadCountrySearchControllersFromPredicate {
    // Query for all countryies in the database.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Country" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];

    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Fetch error %@ %@", error, error.userInfo);
        return;
    }
    
    NSArray * countryComparisons;
    if ([self.countriesPredicate isMemberOfClass:[NSCompoundPredicate class]]) {
        countryComparisons = ((NSCompoundPredicate *)self.countriesPredicate).subpredicates;
    }
    else if ([self.countriesPredicate isMemberOfClass:[NSComparisonPredicate class]]) {
        countryComparisons = [NSArray arrayWithObject:self.countriesPredicate];
    }
    
    //NSLog(@"loadCountrySearchControllersFromPredicate num comparisons is %ld", countryComparisons.count);
    
    self.countriesInSearch = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    self.countriesNotInSearch = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    
    for (NSUInteger i=0; i<fetchedObjects.count; i++) {
        Country * country = [fetchedObjects objectAtIndex:i];
        bool matchFound = NO;
        
        for (NSUInteger j=0; j<countryComparisons.count; j++) {
            NSExpression * rightExpression = ((NSComparisonPredicate *) [countryComparisons objectAtIndex:j]).rightExpression;
        
            //NSLog(@"  comparison[%ld] is %@   rightExpressionType=%ld", j, rightExpression.constantValue, rightExpression.expressionType);
            
            if ([country.country_sort_id isEqualToNumber:rightExpression.constantValue]) {
                [self.countriesInSearch addObject:country];
                matchFound = YES;
            }
        }
        
        // If no comparisons were found, load into the countriesNotInSearch
        if (!matchFound) {
            [self.countriesNotInSearch addObject:[fetchedObjects objectAtIndex:i]];
        }
    }
    
    [self.countriesInSearchController setContent:self.countriesInSearch];
    [self.countriesNotInSearchController setContent:self.countriesNotInSearch];
}

// Parse the sectionPredicate to find out the current sections
// used in the search.  Use this information, along with a fetch
// quary, to populate the section search controllers.
- (void)loadSectionsSearchControllersFromPredicate {
    // Query for all sections in the database.
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalogGroup" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (fetchedObjects == nil) {
        NSLog(@"Fetch error %@ %@", error, error.userInfo);
        return;
    }
    
    NSArray * comparisons;
    if ([self.sectionsPredicate isMemberOfClass:[NSCompoundPredicate class]]) {
        comparisons = ((NSCompoundPredicate *)self.sectionsPredicate).subpredicates;
    }
    else if ([self.sectionsPredicate isMemberOfClass:[NSComparisonPredicate class]]) {
        comparisons = [NSArray arrayWithObject:self.sectionsPredicate];
    }
    
    //NSLog(@"loadSectionsSearchControllersFromPredicate num comparisons is %ld", comparisons.count);
    
    self.sectionsInSearch = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    self.sectionsNotInSearch = [NSMutableArray arrayWithCapacity:fetchedObjects.count];
    
    for (NSUInteger i=0; i<fetchedObjects.count; i++) {
        GPCatalogGroup * section = [fetchedObjects objectAtIndex:i];
        bool matchFound = NO;
        
        for (NSUInteger j=0; j<comparisons.count; j++) {
            NSExpression * rightExpression = ((NSComparisonPredicate *) [comparisons objectAtIndex:j]).rightExpression;
            
            //NSLog(@"  comparison[%ld] is %@   rightExpressionType=%ld", j, rightExpression.constantValue, rightExpression.expressionType);
            
            if ([section.group_number isEqualToString:rightExpression.constantValue]) {
                [self.sectionsInSearch addObject:section];
                matchFound = YES;
            }
        }
        
        // If no comparisons were found, load into the countriesNotInSearch
        if (!matchFound) {
            [self.sectionsNotInSearch addObject:[fetchedObjects objectAtIndex:i]];
        }
    }
    
    [self.sectionsInSearchController setContent:self.sectionsInSearch];
    [self.sectionsNotInSearchController setContent:self.sectionsNotInSearch];
}

// Parse the filterPredicate to find out the current filters
// used in the search.  Set attributes in this class to reflect
// the expressions in the predicate.
- (void)loadFiltersSearchAttributesFromPredicate {
    NSArray * comparisons;
    if ([self.filtersPredicate isMemberOfClass:[NSCompoundPredicate class]]) {
        comparisons = ((NSCompoundPredicate *)self.filtersPredicate).subpredicates;
    }
    else if ([self.filtersPredicate isMemberOfClass:[NSComparisonPredicate class]]) {
        comparisons = [NSArray arrayWithObject:self.filtersPredicate];
    }
    
    NSUInteger filterCount = 0;
    NSString * filterDescription = @"none";
    
    for (NSUInteger i=0; i<comparisons.count; i++) {
        NSExpression * leftExpression = ((NSComparisonPredicate *) [comparisons objectAtIndex:i]).leftExpression;
        
        //NSLog(@"  comparison[%ld] is %@", i, leftExpression.keyPath);
        
        if ([leftExpression.keyPath isEqualToString:@"always_display"]) {
            self.filterByAlwaysDisplay = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"very_rare"]) {
            self.filterByVeryRare = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"hidden"]) {
            self.filterByHidden = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"color_variety"]) {
            self.filterByColorVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"gum_variety"]) {
            self.filterByGumVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"plate_variety"]) {
            self.filterByPlateVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"tag_variety"]) {
            self.filterByTagVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"print_variety"]) {
            self.filterByPrintVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"color_error"]) {
            self.filterByColorError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"tag_error"]) {
            self.filterByTagError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"plate_error"]) {
            self.filterByPlateError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"perf_error"]) {
            self.filterByPerfError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"multiple_transfer"]) {
            self.filterByMultipleTransfer = [NSNumber numberWithBool:YES];
            filterCount++;
        }
    }
    
    if (filterCount > 0) {
        self.filterSearchEnabled = [NSNumber numberWithBool:YES];
        
        if (filterCount > 1) {
            filterDescription = @"some";
        }
        else {
            filterDescription = @"one";
        }
    }
    
    [self.filtersSelected setStringValue:filterDescription];
}

// Update the current search based on the three saved compound predicates.
- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:4];
    [predicateArray addObject:[NSPredicate predicateWithFormat:BASE_GP_CATALOG_QUERY]];
    
    if (self.countriesPredicate != nil) {
        [predicateArray addObject:self.countriesPredicate];
    }
    
    if (self.sectionsPredicate != nil) {
        [predicateArray addObject:self.sectionsPredicate];
    }
    
    if (self.filtersPredicate != nil) {
        [predicateArray addObject:self.filtersPredicate];
    }
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.currentSearch = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.currentSearch = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    // Persist the search.
    self.storedAssistedSearch.predicate = self.currentSearch;
    
    [self.document saveInPlace];
    
    // Refetch the GP Catalog Data.
    [self queryGPCatalog];
}


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        self.subvarietiesActive = NO;
        
        // Create the sort descripors
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[gpCountrySort, groupSort, catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        self.altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        self.altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *gpSetSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.gpCatalogSetsSortDescriptors = @[gpSetSort];
        
        NSSortDescriptor *plateUsageSort = [[NSSortDescriptor alloc] initWithKey:@"plate_number" ascending:YES];
        self.plateUsageSortDescriptors = @[plateUsageSort];
        
        NSSortDescriptor *plateNumber1Sort = [[NSSortDescriptor alloc] initWithKey:@"plate1" ascending:YES];
        NSSortDescriptor *plateNumber2Sort = [[NSSortDescriptor alloc] initWithKey:@"plate2" ascending:YES];
        self.plateNumberSortDescriptors = @[plateNumber1Sort, plateNumber2Sort];
        
        NSSortDescriptor *cachetSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cachet_number" ascending:YES];
        self.cachetSortDescriptors = @[cachetSort];
        
        NSSortDescriptor *precancelSort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        self.precancelsSortDescriptors = @[precancelSort];
        
        NSSortDescriptor *cancelationSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cancelation_number" ascending:YES];
        self.cancelationsSortDescriptors = @[cancelationSort];
        
        NSSortDescriptor *looksLikeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.looksLikeSortDescriptors = @[looksLikeSort];
        
        NSSortDescriptor *topicsSort = [[NSSortDescriptor alloc] initWithKey:@"topic_name" ascending:YES];
        self.topicsSortDescriptors = @[topicsSort];
        
        NSSortDescriptor *identPicsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.identificationPicturesSortDescriptors = @[identPicsSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.identScroller setDocumentView:self.identScrollContent];
    [self.infoScroller setDocumentView:self.infoScrollContent];
    [self.platesScroller setDocumentView:self.platesScrollContent];
    
    // Set the scrollers to the top.
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.identScroller documentView] frame]) -
                                    [[self.identScroller contentView] bounds].size.height);
    [[self.identScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.infoScroller documentView] frame]) -
                                    [[self.infoScroller contentView] bounds].size.height);
    [[self.infoScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.platesScroller documentView] frame]) -
                                    [[self.platesScroller contentView] bounds].size.height);
    [[self.platesScroller documentView] scrollPoint:newOrigin];
    
    // Create a panel used to help the user select a set.
    self.addToSetPanel = [[NSPanel alloc] initWithContentRect:self.addToSetSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToSetPanel setContentView:self.addToSetSelector];
    
    // Create a panel to help user select a looks like.
    self.addToLooksLikePanel = [[NSPanel alloc] initWithContentRect:self.addToLooksLikeSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToLooksLikePanel setContentView:self.addToLooksLikeSelector];
    
    // Create assisted search panels.
    self.countriesSearchPanel = [[NSPanel alloc] initWithContentRect:self.countriesSearchContent.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countriesSearchPanel setContentView:self.countriesSearchContent];
    self.sectionsSearchPanel = [[NSPanel alloc] initWithContentRect:self.sectionsSearchContent.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionsSearchPanel setContentView:self.sectionsSearchContent];
    self.filtersSearchPanel = [[NSPanel alloc] initWithContentRect:self.filtersSearchContent.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.filtersSearchPanel setContentView:self.filtersSearchContent];
    
    // Initialize the current GP catalog search last used by the user.
    [self initCurrentSearch];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"GP Catalog Editor";
}

- (void)queryGPCatalog {
    // (re)set the content inside the GPCatalog entries controller.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:self.currentSearch];
    
    // Execute the query
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Fetch error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    self.gpCatalogEntries = [NSMutableArray arrayWithArray:results];
    [self.gpCatalogEntriesController setContent:self.gpCatalogEntries];
}

- (void)querySubvarieties {
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    [fetchRequest setPredicate:self.subvarietiesSearch];
    
    // Execute the query
    NSError *error = nil;
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Fetch error %@, %@", error, [error userInfo]);
	    abort();
    }
    
    self.gpCatalogEntries = [NSMutableArray arrayWithArray:results];
    [self.gpCatalogEntriesController setContent:self.gpCatalogEntries];
}

- (IBAction)openAddToGPCatalog:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPAddToCatalogController * controller = [[GPAddToCatalogController alloc] initWithWindowNibName:@"GPAddToCatalogController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setCatalogEditor:self];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddSubvariety:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    GPCatalog * entry = nil;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * possibleEntry = [entries objectAtIndex:0];
        // Only allow creation of subvarieties on top-level major varieties.
        if (possibleEntry.majorVariety == nil) {
            entry = possibleEntry;
        }
        else {
            // If this is clicked from the subvarieties screen, add another
            // subvariety to the major variety of the selected entry.
            entry = possibleEntry.majorVariety;
        }
    }
    
    if (entry == nil) return;
    
    GPAddSubvariety * controller = [[GPAddSubvariety alloc] initWithWindowNibName:@"GPAddSubvariety"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setTheMajorVariety:entry];
    [controller setCatalogEditor:self];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)duplicateGPCatalogEntry:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<entries.count; i++) {
        GPCatalog * entry = [entries objectAtIndex:i];
        [entry duplicateFromThis];
    }
    
    [self.document saveInPlace];
    
    if (self.subvarietiesActive)
        [self querySubvarieties];
    else
        [self queryGPCatalog];
}

- (IBAction)removeSelectedGPCatalogEntries:(id)sender {
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<selectedEntries.count; i++) {
        GPCatalog * entry = [selectedEntries objectAtIndex:i];
        [self.managedObjectContext deleteObject:entry];
    }
    
    if (self.subvarietiesActive)
        [self querySubvarieties];
    else
        [self queryGPCatalog];
}

- (IBAction)addToGPCatalogSet:(id)sender {
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToSetPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToSet:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
 
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        NSArray * setList = [self.gpCatalogSetsController arrangedObjects];
        if (setList == nil) return;
        
        NSInteger selectedSetIndex = self.setSelectorCombo.indexOfSelectedItem;
        if (selectedSetIndex == -1) return;
        
        GPCatalogSet * catalogSet = [setList objectAtIndex:selectedSetIndex];
        [catalogSet addGpCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];        
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToSetPanel];
    [self.addToSetPanel close];
}

- (IBAction)addToLooksLike:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToLooksLikePanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToLooksLike:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
    
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        LooksLike * ll;
        NSArray * selectedLooksLike = self.looksLikeController.selectedObjects;
        if (selectedLooksLike == nil) return;
        
        ll = [selectedLooksLike objectAtIndex:0];
        if (ll == nil) return;
        
        [ll addTheseGPCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToLooksLikePanel];
    [self.addToLooksLikePanel close];
}

- (IBAction)manageSets:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPSetController * controller = [[GPSetController alloc] initWithWindowNibName:@"GPSetController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageLooksLike:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPLooksLikeController * controller = [[GPLooksLikeController alloc] initWithWindowNibName:@"GPLooksLikeController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageTopics:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPTopicsController * controller = [[GPTopicsController alloc] initWithWindowNibName:@"GPTopicsController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.countriesSearchPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.sectionsSearchPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)openFiltersSearchPanel:(id)sender {
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.filtersSearchPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)closeCountriesSearchPanel:(id)sender {
    // Create ComparisonPredicates for each selected country.
    // If there is more than one country, the comparison predicates
    // must be placed into a compound predicate.
    NSArray * selectedCountries = self.countriesInSearchController.content;
    if (selectedCountries == nil || selectedCountries.count == 0) {
        self.countriesPredicate = nil;
    }
    else if (selectedCountries.count == 1) {
        Country * country = [selectedCountries objectAtIndex:0];
    
        self.countriesPredicate = [NSPredicate predicateWithFormat:@"country.country_sort_id == %@", country.country_sort_id];
    }
    else if (selectedCountries.count > 1) {
        NSMutableArray * countriesPredicateArray = [NSMutableArray arrayWithCapacity:selectedCountries.count];
        for (NSUInteger i=0; i<selectedCountries.count; i++) {
            Country * country = [selectedCountries objectAtIndex:i];
            NSPredicate * countryPredicate = [NSPredicate predicateWithFormat:@"country.country_sort_id == %@", country.country_sort_id];
            [countriesPredicateArray addObject:countryPredicate];
        }
        
        // OR together all the countries using a compound predicate.
        self.countriesPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:countriesPredicateArray];
    }
    
    // Update the current search with the chages to this
    // predicate.
    [self updateCurrentSearch];
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.countriesSearchPanel];
    [self.countriesSearchPanel close];
}

- (IBAction)closeSectionsSearchPanel:(id)sender {
    NSArray * selectedSections = self.sectionsInSearchController.content;
    if (selectedSections == nil || selectedSections.count == 0) {
        self.sectionsPredicate = nil;
    }
    else if (selectedSections.count == 1) {
        GPCatalogGroup * section = [selectedSections objectAtIndex:0];
        
        self.sectionsPredicate = [NSPredicate predicateWithFormat:@"catalogGroup.group_number == %@", section.group_number];
    }
    else if (selectedSections.count > 1) {
        NSMutableArray * sectionsPredicateArray = [NSMutableArray arrayWithCapacity:selectedSections.count];
        for (NSUInteger i=0; i<selectedSections.count; i++) {
            GPCatalogGroup * section = [selectedSections objectAtIndex:i];
            NSPredicate * predicate = [NSPredicate predicateWithFormat:@"catalogGroup.group_number == %@", section.group_number];
            [sectionsPredicateArray addObject:predicate];
        }
        
        // OR together all the countries using a compound predicate.
        self.sectionsPredicate = [NSCompoundPredicate orPredicateWithSubpredicates:sectionsPredicateArray];
    }
    
    // Update the current search with the chages to this
    // predicate.
    [self updateCurrentSearch];
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.sectionsSearchPanel];
    [self.sectionsSearchPanel close];
}

- (IBAction)closeFiltersSearchPanel:(id)sender {
    NSString * filterDescription = @"none";
    
    if ([self.filterSearchEnabled isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSMutableArray * predicates = [NSMutableArray arrayWithCapacity:20];
        
        if ([self.filterByAlwaysDisplay isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"always_display == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterByVeryRare isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"very_rare == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterByHidden isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"hidden == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByColorVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"color_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByGumVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"gum_display == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPlateVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"plate_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByTagVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"tag_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPrintVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"print_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByColorError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"color_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByTagError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"tag_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPlateError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"plate_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPerfError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"perf_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByMultipleTransfer isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"multiple_transfer == yes"];
            [predicates addObject:pred];
        }
        
        if (predicates.count == 0) {
            self.filtersPredicate = nil;
        }
        else if (predicates.count == 1) {
            self.filtersPredicate = [predicates objectAtIndex:0];
            filterDescription = @"one";
        }
        else if (predicates.count > 1) {
            self.filtersPredicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
            filterDescription = @"some";
        }
    }
    else {
        self.filtersPredicate = nil;
    }
    
    // Update the filter description.
    [self.filtersSelected setStringValue:filterDescription];
    
    // Update the current search with the chages to this
    // predicate.
    [self updateCurrentSearch];
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.filtersSearchPanel];
    [self.filtersSearchPanel close];
}

- (IBAction)includeCountriesInSearch:(id)sender {
    NSArray * selectedCountries = self.countriesNotInSearchController.selectedObjects;
    
    [self.countriesInSearchController addObjects:selectedCountries];
    [self.countriesNotInSearchController removeObjects:selectedCountries];
}

- (IBAction)excludeCountriesFromSearch:(id)sender {
    NSArray * selectedCountries = self.countriesInSearchController.selectedObjects;
    
    [self.countriesNotInSearchController addObjects:selectedCountries];
    [self.countriesInSearchController removeObjects:selectedCountries];
}

- (IBAction)includeSectionsInSearch:(id)sender {
    NSArray * selectedSections = self.sectionsNotInSearchController.selectedObjects;
    
    [self.sectionsInSearchController addObjects:selectedSections];
    [self.sectionsNotInSearchController removeObjects:selectedSections];
}

- (IBAction)excludeSectionsFromSearch:(id)sender {
    NSArray * selectedSections = self.sectionsInSearchController.selectedObjects;
    
    [self.sectionsNotInSearchController addObjects:selectedSections];
    [self.sectionsInSearchController removeObjects:selectedSections];
}

- (IBAction)viewSubvarieties:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    GPCatalog * theMajorVariety = nil;
    NSArray * selectedObjects = self.gpCatalogEntriesController.selectedObjects;
    if (selectedObjects != nil)
        theMajorVariety = [selectedObjects objectAtIndex:0];
    
    if (theMajorVariety != nil && (theMajorVariety.subvarieties.count > 0)) {
        self.subvarietiesSearch = [NSPredicate predicateWithFormat:@"majorVariety.gp_catalog_number like %@", theMajorVariety.gp_catalog_number];
        
        [self querySubvarieties];
        
        // Set the selection to the first subvariety.
        [self.gpCatalogEntriesController setSelectionIndex:0];
        
        self.subvarietiesActive = YES;
    }
}

- (IBAction)closeSubvarieties:(id)sender {
    // Get the major variety from the selection.
    GPCatalog * theMajorVariety = nil;
    NSArray * selectedObjects = self.gpCatalogEntriesController.selectedObjects;
    if (selectedObjects != nil) {
        GPCatalog * entry = [selectedObjects objectAtIndex:0];
        theMajorVariety = entry.majorVariety;
    }
    
    // Restore the current search.
    [self queryGPCatalog];
    
    [self.gpCatalogEntriesController setSelectedObjects:@[theMajorVariety]];
    
    // Make sure the selection is visable.
    NSUInteger selRow = self.gpCatalogEntriesController.selectionIndex;
    [self.gpCatalogTable scrollRowToVisible:selRow];
    
    self.subvarietiesActive = NO;
}

- (IBAction)viewSetsForGPCatalogEntry:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    NSButton * llButton = (NSButton *)sender;
    
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    if (selectedEntries == nil) return;
    
    GPCatalog * selectedEntry = [selectedEntries objectAtIndex:0];
    [self.setsPopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.setsPopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)viewLooksLikeForGPCatalogEntry:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    NSButton * llButton = (NSButton *)sender;
    
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    if (selectedEntries == nil) return;
    
    GPCatalog * selectedEntry = [selectedEntries objectAtIndex:0];
    [self.looksLikePopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.looksLikePopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)addAlternateCatalog:(id)sender {
    [self.altCatalogsController add:self];
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.default_picture = fileName;
    }
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_1 = fileName;
      }
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_2 = fileName;
    }
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_3 = fileName;
    }
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_4 = fileName;
    }
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_5 = fileName;
    }
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_6 = fileName;
    }
}

- (IBAction)addIdentificationPicture:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    GPPicture * identPic = [NSEntityDescription insertNewObjectForEntityForName:@"GPPicture" inManagedObjectContext:self.managedObjectContext];
    identPic.filename = fileName;
    
    [entry addExtraPicturesObject:identPic];
}

- (IBAction)removeIdentificationPicture:(id)sender {
    NSArray * selectedIdentPics = self.identificationPicturesController.selectedObjects;
    if (selectedIdentPics == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeExtraPictures:[NSSet setWithArray:selectedIdentPics]];
}

- (IBAction)addPlateUsage:(id)sender {
    PlateUsage * pu = [NSEntityDescription insertNewObjectForEntityForName:@"PlateUsage" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    // Increment the plate_number based on number of plate usages present.
    NSUInteger nextPlateNumber = entry.plateUsage.count + 1;
    [pu setPlate_number:[NSNumber numberWithUnsignedInteger:nextPlateNumber]];
    
    [entry addPlateUsageObject:pu];
}

- (IBAction)removePlateUsage:(id)sender {
    NSArray * selectedPlateUsages = self.plateUsageController.selectedObjects;
    if (selectedPlateUsages == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateUsage:[NSSet setWithArray:selectedPlateUsages]];
}

- (IBAction)addPlateNumberCombination:(id)sender {
    PlateNumber * pn = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addPlateNumbersObject:pn];
}

- (IBAction)removePlateNumberCombination:(id)sender {
    NSArray * selectedPlateNumbers = self.plateNumberCombinationsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateNumbers:[NSSet setWithArray:selectedPlateNumbers]];
}

- (IBAction)addCachet:(id)sender {
    Cachet * cachet = [NSEntityDescription insertNewObjectForEntityForName:@"Cachet" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addCachetsObject:cachet];
}

- (IBAction)removeCachet:(id)sender {
    NSArray * selectedCachets = self.cachetController.selectedObjects;
    if (selectedCachets == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeCachets:[NSSet setWithArray:selectedCachets]];
}

- (IBAction)addPrecancel:(id)sender {
    BureauPrecancel * precancel = [NSEntityDescription insertNewObjectForEntityForName:@"BureauPrecancel" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addBureauPrecancelsObject:precancel];
}

- (IBAction)removePrecancel:(id)sender {
    NSArray * selectedPrecancels = self.precancelsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeBureauPrecancels:[NSSet setWithArray:selectedPrecancels]];
}

- (IBAction)addPictureToPrecancel:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * selectedPrecancels = self.precancelsController.selectedObjects;
    if (selectedPrecancels == nil) return;
    BureauPrecancel * precancel = [selectedPrecancels objectAtIndex:0];
    
    [precancel setPicture:fileName];
}

- (IBAction)addCancelation:(id)sender {
    Cancelations * cancelation = [NSEntityDescription insertNewObjectForEntityForName:@"Cancelations" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addCancelationsObject:cancelation];
}

- (IBAction)removeCancelation:(id)sender {
    NSArray * selectedCancelations = self.cancelationsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeCancelations:[NSSet setWithArray:selectedCancelations]];
}

- (IBAction)addTopic:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addTopicsObject:self.selectedTopic];
}

- (IBAction)removeTopic:(id)sender {
    NSArray * topics = self.topicsController.selectedObjects;
    if (topics == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeTopics:[NSSet setWithArray:topics]];
}

@end
