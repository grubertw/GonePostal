//
//  GPAddToCatalogController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalogEditor.h"

@interface GPAddToCatalogController : NSWindowController <NSWindowDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic) GPCatalogEditor * catalogEditor;

@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogNamesSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * gpCatalogEntryController;
@property (weak, nonatomic) IBOutlet NSArrayController * countriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * formatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogNamesController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogSectionsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpGroupsController;

@property (weak, nonatomic) IBOutlet NSTextField * quantityInput;

@end
