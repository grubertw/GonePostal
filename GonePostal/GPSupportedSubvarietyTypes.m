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

- (IBAction)addSubvarietyType:(id)sender {
    [self.subvarietyTypesController insert:sender];
    [self.managedObjectContext save:nil];
}

- (IBAction)deleteSubvarietyType:(id)sender {
    [self.subvarietyTypesController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet;
        
        if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
            && [error code] == NSValidationRelationshipDeniedDeleteError) {
            errSheet = [[NSAlert alloc] init];
            [errSheet setMessageText:@"Delete Error"];
            [errSheet setInformativeText:@"Item is currently in use within the GP Catalog."];
        }
        else {
            errSheet = [NSAlert alertWithError:error];
        }
        
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

@end
