//
//  GPSupportedCountriesController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSupportedCountriesController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * countryDataController;

- (IBAction)addCountry:(id)sender;
- (IBAction)deleteCountry:(id)sender;
- (IBAction)reSort:(id)sender;

@end
