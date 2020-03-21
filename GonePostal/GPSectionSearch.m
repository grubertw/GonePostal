//
//  GPSectionSearch.m
//  GonePostal
//
//  Created by Travis Gruber on 3/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSectionSearch.h"
#import "GPCatalogGroup.h"
#import "GonePostal-Swift.h"

static NSString * PREDICATE_FORMAT_FOR_STAMP = @"gpCatalog.catalogGroup.group_number == %@";
static NSString * PREDICATE_FORMAT_FOR_GPCATALG = @"catalogGroup.group_number == %@";

@interface GPSectionSearch ()
@property (weak, nonatomic) IBOutlet NSArrayController * itemsInSearchController;
@property (weak, nonatomic) IBOutlet NSArrayController * itemsNotInSearchController;

@property bool isStampPredicate;
@end

@implementation GPSectionSearch

// Parse the predicate to find out the current items
// used in the search.  Use this information, along with a fetch
// quary, to populate the search controllers.
- (void)loadSearchControllersFromPredicate {
    // Query for all countryies in the database.
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
    if ([self.predicate isMemberOfClass:[NSCompoundPredicate class]]) {
        comparisons = ((NSCompoundPredicate *)self.predicate).subpredicates;
    }
    else if ([self.predicate isMemberOfClass:[NSComparisonPredicate class]]) {
        comparisons = [NSArray arrayWithObject:self.predicate];
    }
    
    //NSLog(@"loadSearchControllersFromPredicate num comparisons is %ld", comparisons.count);
    
    for (NSUInteger i=0; i<fetchedObjects.count; i++) {
        GPCatalogGroup * item = [fetchedObjects objectAtIndex:i];
        bool matchFound = NO;
        
        for (NSUInteger j=0; j<comparisons.count; j++) {
            NSExpression * rightExpression = ((NSComparisonPredicate *) [comparisons objectAtIndex:j]).rightExpression;
            
            //NSLog(@"  comparison[%ld] is %@   rightExpressionType=%ld", j, rightExpression.constantValue, rightExpression.expressionType);
            
            if ([item.group_number isEqualToString:rightExpression.constantValue]) {
                [self.itemsInSearch addObject:item];
                matchFound = YES;
            }
        }
        
        // If no comparisons were found, load into the countriesNotInSearch
        if (!matchFound) {
            [self.itemsNotInSearch addObject:[fetchedObjects objectAtIndex:i]];
        }
    }
    
    [self.itemsInSearchController setContent:self.itemsInSearch];
    [self.itemsNotInSearchController setContent:self.itemsNotInSearch];
}

- (id)initWithPredicate:(NSPredicate *)predicate forStamp:(bool)isStampPredicate
{
    self = [super initWithNibName:@"GPSectionSearch" bundle:nil];
    if (self) {
        _itemsInSearch = [NSMutableArray arrayWithCapacity:0];
        _itemsNotInSearch = [NSMutableArray arrayWithCapacity:0];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"group_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        _isStampPredicate = isStampPredicate;
        _predicate = predicate;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    [self loadSearchControllersFromPredicate];
}

- (IBAction)includeInSearch:(id)sender {
    NSArray * selectedItems = self.itemsNotInSearchController.selectedObjects;
    
    [self.itemsInSearch addObjectsFromArray:selectedItems];
    [self.itemsNotInSearch removeObjectsInArray:selectedItems];
    
    [self.itemsInSearchController setContent:self.itemsInSearch];
    [self.itemsNotInSearchController setContent:self.itemsNotInSearch];
}

- (IBAction)excludeFromSearch:(id)sender {
    NSArray * selectedItems = self.itemsInSearchController.selectedObjects;
    
    [self.itemsNotInSearch addObjectsFromArray:selectedItems];
    [self.itemsInSearch removeObjectsInArray:selectedItems];
    
    [self.itemsInSearchController setContent:self.itemsInSearch];
    [self.itemsNotInSearchController setContent:self.itemsNotInSearch];
}

- (IBAction)saveSearch:(id)sender {
    // Create ComparisonPredicates for each selected item.
    // If there is more than one item, the comparison predicates
    // must be placed into a compound predicate.
    NSArray * selectedItems = self.itemsInSearchController.content;
    NSMutableArray * predicates = [NSMutableArray arrayWithCapacity:selectedItems.count];
    
    for (NSUInteger i=0; i<selectedItems.count; i++) {
        GPCatalogGroup * item = [selectedItems objectAtIndex:i];
        
        NSPredicate * itemPredicate;
        if (self.isStampPredicate)
            itemPredicate = [NSPredicate predicateWithFormat:PREDICATE_FORMAT_FOR_STAMP, item.group_number];
        else {
            itemPredicate = [NSPredicate predicateWithFormat:PREDICATE_FORMAT_FOR_GPCATALG, item.group_number];
        }
        
        [predicates addObject:itemPredicate];
    }
    
    if (selectedItems == nil || selectedItems.count == 0) {
        self.predicate = nil;
    }
    else if (selectedItems.count == 1) {
        self.predicate = [predicates objectAtIndex:0];
    }
    else if (selectedItems.count > 1) {
        // OR together all the countries using a compound predicate.
        self.predicate = [NSCompoundPredicate orPredicateWithSubpredicates:predicates];
    }
    
    // End the sheet.
    [self.panel.sheetParent endSheet:self.panel];
    [self.view.window close];
}

@end
