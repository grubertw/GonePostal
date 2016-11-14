//
//  GPSupportedStampFormats.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedStampFormats.h"

@interface GPSupportedStampFormats ()
@property (weak, nonatomic) IBOutlet NSTableView * stampFormatsTable;

@property (weak, nonatomic) IBOutlet NSPopover * allowedFormatTypesPopover;
@property (strong, nonatomic) IBOutlet NSArrayController * allowedFormatTypes;

@property (strong, nonatomic) IBOutlet NSArrayController * modelController;
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

- (IBAction)editAllowedStampFormats:(NSButton *)sender {
    NSInteger row = [self.stampFormatsTable rowForView:sender];
    self.selectedStampFormat = self.modelController.arrangedObjects[row];
    
    [self.allowedFormatTypesPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:row];
}

- (IBAction)addToAllowedFormatTypes:(id)sender {
    [self.selectedStampFormat addContainersObject:self.formatTypeToAdd];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeFromAllowedFormatTypes:(id)sender {
    [self.allowedFormatTypes remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)addStampFormat:(id)sender {
    [self.modelController insert:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)deleteStampFormat:(id)sender {
    [self.modelController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet;
        
        if (   [[error domain] isEqualToString:NSCocoaErrorDomain]
            && [error code] == NSValidationRelationshipDeniedDeleteError) {
            errSheet = [[NSAlert alloc] init];
            [errSheet setMessageText:@"Delete Error"];
            [errSheet setInformativeText:@"Item is currently in use within a stamp collection."];
        }
        else {
            errSheet = [NSAlert alertWithError:error];
        }
        
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

@end
