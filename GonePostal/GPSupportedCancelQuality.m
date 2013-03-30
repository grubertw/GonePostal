//
//  GPSupportedCancelQuality.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedCancelQuality.h"

@interface GPSupportedCancelQuality ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedCancelQuality

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
    return @"Supported Cancel Quality";
}

- (IBAction)addCancelQuality:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deleteCancelQuality:(id)sender {
    [self.modelController remove:self];
}

@end
