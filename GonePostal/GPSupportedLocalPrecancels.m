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
    for (LocalPrecancel * lc in self.modelController.selectedObjects) {
        NSString * fileName = [self.document addPictureToWrapperUsingGPID:lc.gp_precancel_number forAttribute:@"picture"];
        if (fileName == nil) return;
        lc.picture = fileName;
    }
}

- (IBAction)addPrecancel:(id)sender {
    [self.modelController insert:self];
    [self.managedObjectContext save:nil];
}

- (IBAction)deletePrecancel:(id)sender {
    [self.modelController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet;
        
        if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
            && [error code] == NSValidationRelationshipDeniedDeleteError) {
            errSheet = [NSAlert alertWithMessageText:@"Delete Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Item is currently in use within a stamp collection."];
        }
        else {
            errSheet = [NSAlert alertWithError:error];
        }
        
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
