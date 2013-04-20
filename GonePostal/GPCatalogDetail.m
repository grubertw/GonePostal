//
//  GPCatalogDetail.m
//  GonePostal
//
//  Created by Travis Gruber on 4/16/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogDetail.h"

@interface GPCatalogDetail ()

@end

@implementation GPCatalogDetail

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog {
    self = [super initWithNibName:@"GPCatalogDetail" bundle:nil];
    if (self) {
        _gpCatalog = gpCatalog;
        _managedObjectContext = gpCatalog.managedObjectContext;
        
        NSSortDescriptor *identPicsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.identificationPicturesSortDescriptors = @[identPicsSort];
    }
    return self;
}

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    self = [super initWithNibName:@"GPCatalogDetail" bundle:nil];
    if (self) {
        _managedObjectContext = managedObjectContext;
        
        NSSortDescriptor *identPicsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.identificationPicturesSortDescriptors = @[identPicsSort];
    }
    return self;
}

@end
