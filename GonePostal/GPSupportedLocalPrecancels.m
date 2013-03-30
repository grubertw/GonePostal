//
//  GPSupportedLocalPrecancels.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedLocalPrecancels.h"
#import "GPDocument.h"
#import "LocalPrecancel.h"

@interface GPSupportedLocalPrecancels ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedLocalPrecancels

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        _sortDescriptors = @[sort];
    }
    
    return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Local Precancels";
}

- (IBAction)addPicture:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    for (LocalPrecancel * lc in self.modelController.selectedObjects) {
        lc.picture = fileName;
    }
}

- (IBAction)addPrecancel:(id)sender {
    [self.modelController insert:self];
}

- (IBAction)deletePrecancel:(id)sender {
    [self.modelController remove:self];
}

@end
