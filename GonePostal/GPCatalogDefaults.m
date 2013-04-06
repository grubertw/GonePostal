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
#import "AlternateCatalog.h"

@interface GPCatalogDefaults ()

@end

@implementation GPCatalogDefaults

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        _countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        _formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        _gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        _altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
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
        
        AlternateCatalog * defaultAltCatalog;
        for (AlternateCatalog * ac in defaults.alternateCatalogs) {
            defaultAltCatalog = ac;
            break;
        }
        
        self.selectedAltCatalogSection = defaultAltCatalog.alternateCatalogGroup;
    }
    else if (results.count == 0) {
        GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
        entry.is_default = [NSNumber numberWithBool:YES];
        
        // Create a row in the AlternateCatalogs table associated with the default.
        // The catalog number for the row is NOT specified.
        AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:self.managedObjectContext];
        [entry addAlternateCatalogsObject:altCatalog];
        
        [self.gpCatalogDefaultsController setContent:entry];
    }
}

- (IBAction)save:(id)sender {
    // Save info into the associated default AlternateCatalog row.
    GPCatalog * defaultEntry = self.gpCatalogDefaultsController.content;
    
    AlternateCatalog * defaultAltCatalog;
    for (AlternateCatalog * ac in defaultEntry.alternateCatalogs) {
        defaultAltCatalog = ac;
        break;
    }
    
    defaultAltCatalog.alternateCatalogName = defaultEntry.defaultCatalogName;
    defaultAltCatalog.alternateCatalogGroup = self.selectedAltCatalogSection;
    
    [self.document saveInPlace];
    
    [self.window performClose:self];
}

- (IBAction)clear:(id)sender {
    GPCatalog * defaults = self.gpCatalogDefaultsController.content;
    [self.managedObjectContext deleteObject:defaults];
    
    GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    entry.is_default = [NSNumber numberWithBool:YES];
    
    // Create a row in the AlternateCatalogs table associated with the default.
    // The catalog number for the row is NOT specified.
    AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:self.managedObjectContext];
    [entry addAlternateCatalogsObject:altCatalog];
    
    [self.gpCatalogDefaultsController setContent:entry];
}

@end
