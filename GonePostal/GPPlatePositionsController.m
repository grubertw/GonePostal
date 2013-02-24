//
//  GPPlatePositionsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlatePositionsController.h"

@interface GPPlatePositionsController ()

@end

@implementation GPPlatePositionsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Plate Positions";
}

- (IBAction)addPlatePosition:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deletePlatePosition:(id)sender {
    [self.modelController remove:self];
}

@end
