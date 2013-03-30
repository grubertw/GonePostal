//
//  GPSupportedFormatsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedFormatsController.h"

@interface GPSupportedFormatsController ()

@end

@implementation GPSupportedFormatsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Format Types";
}

- (IBAction)addFormat:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deleteFormat:(id)sender {
    [self.modelController remove:self];
}

@end
