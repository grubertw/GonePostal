//
//  GPSetPopoverController.h
//  GonePostal
//
//  Created by Travis Gruber on 2/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"

@interface GPSetPopoverController : NSViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * setsSortDescriptors;

@property (strong, nonatomic) GPCatalog * selectedCatalogEntry;
@property (strong, nonatomic) GPCatalogSet * selectedSet;

@property (weak, nonatomic) IBOutlet NSArrayController * setsController;
@property (weak, nonatomic) IBOutlet NSArrayController * setsInGPCatalogController;

- (IBAction)addSetToGPCatalogEntry:(id)sender;
- (IBAction)removeSetFromGPCatalogEntry:(id)sender;

@end
