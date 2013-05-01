//
//  GPSupportedStampFormats.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedStampFormats.h"

@interface GPSupportedStampFormats ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedStampFormats

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSSortDescriptor *formatTypeSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        _formatTypeSortDescriptors = @[formatTypeSort];
    }
    
    return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Formats";
}

- (IBAction)addStampFormat:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deleteStampFormat:(id)sender {
    [self.modelController remove:self];
}

@end
