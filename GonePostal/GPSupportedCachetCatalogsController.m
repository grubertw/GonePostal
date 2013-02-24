//
//  GPSupportedCachetCatalogsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedCachetCatalogsController.h"

@interface GPSupportedCachetCatalogsController ()

@end

@implementation GPSupportedCachetCatalogsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"cachet_catalog_name" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Cachet Catalogs";
}

- (IBAction)addCachetCatalog:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)removeCachetCatalog:(id)sender {
    [self.modelController remove:self];
}

@end
