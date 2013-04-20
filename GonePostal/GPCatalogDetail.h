//
//  GPCatalogDetail.h
//  GonePostal
//
//  Created by Travis Gruber on 4/16/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"

@interface GPCatalogDetail : NSViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) GPCatalog * gpCatalog;

@property (strong, nonatomic) NSArray * identificationPicturesSortDescriptors;

@property (strong, nonatomic) NSDrawer * drawer;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
