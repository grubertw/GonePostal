//
//  GPSupportedCatalogQuantityTypes.m
//  GonePostal
//
//  Created by Travis Gruber on 2/23/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPSupportedCatalogQuantityTypes.h"

@interface GPSupportedCatalogQuantityTypes ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedCatalogQuantityTypes

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
    return @"Supported Catalog Quantity Types";
}

- (IBAction)addSupportedQuantityType:(id)sender {
    [self.modelController add:sender];
    [self.managedObjectContext save:nil];
}

- (IBAction)removeSupportedQuantityType:(id)sender {
    [self.modelController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet;
        
        if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
            && [error code] == NSValidationRelationshipDeniedDeleteError) {
            errSheet = [NSAlert alertWithMessageText:@"Delete Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Item is currently in use within the library."];
        }
        else {
            errSheet = [NSAlert alertWithError:error];
        }
        
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
