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

// Find the alternate calalog number within the GPCatalog entry.
- (id)transformedValue:(id)value {
    if (![value isMemberOfClass:[GPCatalog class]]) return nil;
 
    GPCatalog * gpCatalogEntry = (GPCatalog *)value;
    
    NSString * altCatalogNumber;
    
    // Next, iterate through all the alternate catalogs for this GPCatalog,
    // searching for the default.
    for (AlternateCatalog * altCatalog in gpCatalogEntry.alternateCatalogs) {
        if ([altCatalog.alternateCatalogName.alternate_catalog_name isEqualToString:gpCatalogEntry.defaultCatalogName.alternate_catalog_name]) {
            altCatalogNumber = altCatalog.alternate_catalog_number;
            break;
        }
    }
    
    return altCatalogNumber;
}

@end
