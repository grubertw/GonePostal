//
//  GPSupportedPriceLists.m
//  GonePostal
//
//  Created by Travis Gruber on 8/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedPriceLists.h"

@interface GPSupportedPriceLists ()
@property (weak, nonatomic) IBOutlet NSArrayController * modelController;
@end

@implementation GPSupportedPriceLists

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
    return @"Supported Price Lists";
}

- (IBAction)addPriceList:(id)sender {
    [self.modelController insert:self];
    [self.managedObjectContext save:nil];
}

- (IBAction)removePriceList:(id)sender {
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