//
//  GPCatalogDefaults.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogDefaults.h"
#import "GPCatalog.h"
#import "GPDocument.h"

@interface GPCatalogDefaults ()

@end

@implementation GPCatalogDefaults

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        self.altCatalogsSortDescriptors = @[altCatalogSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Fetch and load the defaults.  If they do not exist, create them.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Error creating entry %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (results.count == 1) {
        GPCatalog * defaults = [results objectAtIndex:0];
        [self.gpCatalogDefaultsController setContent:defaults];
    }
    else if (results.count == 0) {
        GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
        entry.is_default = [NSNumber numberWithBool:YES];
        
        [self.gpCatalogDefaultsController setContent:entry];
    }
}

- (IBAction)save:(id)sender {
    [self.document saveInPlace];
    
    [self.window performClose:self];
}

@end
