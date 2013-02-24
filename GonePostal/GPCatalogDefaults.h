//
//  GPCatalogDefaults.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPCatalogDefaults : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * gpCatalogDefaultsController;

- (IBAction)save:(id)sender;

@end
