//
//  GPSupportedCountriesController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedCountriesController.h"
#import "Country.h"

@interface GPSupportedCountriesController ()

@end

@implementation GPSupportedCountriesController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.sortDescriptors = @[countrySort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Countries";
}

- (IBAction)addCountry:(id)sender {
    NSArray * countries = [self.countryDataController arrangedObjects];
    
    int sortID = 0;
    
    if ([countries count] > 0) {
        Country * lastModel = (Country *)[countries lastObject];
        
        sortID = [lastModel.country_sort_id intValue] + 1;
    }
    
    Country * newModel = [self.countryDataController newObject];
    [newModel setCountry_sort_id:[NSNumber numberWithInt:sortID]];
    
    [self.countryDataController addObject:newModel];
}

- (IBAction)deleteCountry:(id)sender {
    [self.countryDataController remove:self.countryDataController];
}

- (IBAction)reSort:(id)sender {
    [self.countryDataController rearrangeObjects];
}

@end
