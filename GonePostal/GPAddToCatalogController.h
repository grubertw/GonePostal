//
//  GPAddToCatalogController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPAddToCatalogController : NSWindowController <NSWindowDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogNamesSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * gpCatalogEntryController;
@property (weak, nonatomic) IBOutlet NSArrayController * countriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * formatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogNamesController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogSectionsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpGroupsController;

@property (weak, nonatomic) IBOutlet NSTextField * quantityInput;

- (IBAction)addGPCatalogEntries:(id)sender;
- (IBAction)addAlternateCatalogEntry:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)addDefaultPicture:(id)sender;
- (IBAction)addAlternatePicture1:(id)sender;
- (IBAction)addAlternatePicture2:(id)sender;
- (IBAction)addAlternatePicture3:(id)sender;
- (IBAction)addAlternatePicture4:(id)sender;
- (IBAction)addAlternatePicture5:(id)sender;
- (IBAction)addAlternatePicture6:(id)sender;

@end
