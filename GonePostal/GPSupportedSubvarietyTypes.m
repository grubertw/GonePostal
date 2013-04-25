//
//  GPSupportedSubvarietyTypes.m
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedSubvarietyTypes.h"

@interface GPSupportedSubvarietyTypes ()
@property (strong, nonatomic) IBOutlet NSArrayController * subvarietyTypesController;
@end

@implementation GPSupportedSubvarietyTypes

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"sortID" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported GPCatalog subvariety types";
}

@end
