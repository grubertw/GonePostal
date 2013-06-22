//
//  GPSetController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/13/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPCatalogSet.h"

@interface GPSetController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogSetsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogEntriesSortDescriptors;
@property (strong, nonatomic) NSArray * countrySortDescriptors;
@property (strong, nonatomic) NSArray * sectionSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogSetsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogsController;

- (IBAction)addSet:(id)sender;
- (IBAction)removeSet:(id)sender;
- (IBAction)removeCatalogEntries:(id)sender;

@end
