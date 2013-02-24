//
//  GPSupportedAltCatalogSectionsController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedAltCatalogSectionsController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

- (IBAction)addAltCatalogSection:(id)sender;
- (IBAction)deleteAltCatalogSectiom:(id)sender;
- (IBAction)reSort:(id)sender;

@end
