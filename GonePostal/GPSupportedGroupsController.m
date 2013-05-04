//
//  GPSupportedGroupsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedGroupsController.h"

@interface GPSupportedGroupsController ()

@end

@implementation GPSupportedGroupsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported GP Sections";
}

- (IBAction)addGroup:(id)sender {
    [self.modelController insert:self];
    [self.managedObjectContext save:nil];
}

- (IBAction)deleteGroup:(id)sender {
    [self.modelController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet;
        
        if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
            && [error code] == NSValidationRelationshipDeniedDeleteError) {
            errSheet = [NSAlert alertWithMessageText:@"Delete Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Item is currently in use within the GP Catalog."];
        }
        else {
            errSheet = [NSAlert alertWithError:error];
        }
        
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
