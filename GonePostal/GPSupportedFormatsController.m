//
//  GPSupportedFormatsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedFormatsController.h"
#import "GPDocument.h"

@interface GPSupportedFormatsController ()
@property (weak, nonatomic) IBOutlet NSTableView *formatTypesTable;
@property (weak, nonatomic) IBOutlet NSPopover *allowedFormatsPopover;

@property (strong, nonatomic) IBOutlet NSArrayController *allowedStampFormats;
@end

@implementation GPSupportedFormatsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.sortDescriptors = @[sort];
        
        NSSortDescriptor *sfSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.stampFormatSortDescriptors = @[sfSort];
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

- (IBAction)editAllowedStampFromats:(NSButton *)sender {
    NSInteger row = [self.formatTypesTable rowForView:sender];
    self.selectedFormatType = self.modelController.arrangedObjects[row];
    
    [self.allowedFormatsPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:row];
}

- (IBAction)addToAllowedStampFormats:(id)sender {
    [self.selectedFormatType addAllowedStampFormatsObject:self.stampFormatToAdd];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeFromAllowedStampFormats:(id)sender {
    [self.allowedStampFormats remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addFormat:(id)sender {
    [self.modelController insert:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)deleteFormat:(id)sender {
    [self.modelController remove:self];
    
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
