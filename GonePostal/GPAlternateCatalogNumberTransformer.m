//
//  GPAlternateCatalogNumberTransformer.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAlternateCatalogNumberTransformer.h"
#import "GPCatalog.h"
#import "AlternateCatalogName.h"
#import "AlternateCatalog.h"

@implementation GPAlternateCatalogNumberTransformer

+ (Class)transformedValueClass { return [NSString class]; }
+ (BOOL)allowsReverseTransformation { return NO; }

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super init];
    if (self) {
        self.managedObjectContext = managedObjectContext;
    }
    return self;
}

// Transform a default catalog name into it's associated
// alternate catalog number, based on the gp catalog ID.
- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    // First get the GPCatalog based on GPID
    NSEntityDescription *gpCatalogEntity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *gpCatalogFetch = [[NSFetchRequest alloc] init];
    [gpCatalogFetch setEntity:gpCatalogEntity];
    
    NSPredicate *gpCatalogQuery = [NSPredicate predicateWithFormat:@"(gp_catalog_number like %@)", value];
    [gpCatalogFetch setPredicate:gpCatalogQuery];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:gpCatalogFetch error:&error];
    if (results == nil) {
        NSLog(@"Error fetching entry %@, %@", error, [error userInfo]);
	    return nil;
    }

    if (results.count != 1) return nil;
    GPCatalog * gpCatalogEntry = [results objectAtIndex:0];
    
    // Next, iterate through all the alternate catalogs for this GPCatalog,
    // searching for the default.
    NSEnumerator * setEnum = gpCatalogEntry.alternateCatalogs.objectEnumerator;
    AlternateCatalog * altCatalog;
    
    NSString * altCatalogNumber = nil;
    while ((altCatalog = [setEnum nextObject])) {
        if ([altCatalog.alternateCatalogName.alternate_catalog_name isEqualToString:gpCatalogEntry.defaultCatalogName.alternate_catalog_name]) {
            altCatalogNumber = altCatalog.alternate_catalog_number;
            break;
        }
    }
    
    return altCatalogNumber;
}

@end
