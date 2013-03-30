//
//  GPSupportedPerfinCatalogs.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedPerfinCatalogs.h"

@interface GPSupportedPerfinCatalogs ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedPerfinCatalogs

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sortDescriptors = @[sort];
    }
    
    return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Perfin Catalogs";
}

- (IBAction)addPerfinCatalog:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deletePerfinCatalog:(id)sender {
    [self.modelController remove:self];
}

@end
