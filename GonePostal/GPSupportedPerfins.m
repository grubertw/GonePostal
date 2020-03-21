//
//  GPSupportedPerfins.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedPerfins.h"
#import "GonePostal-Swift.h"

@interface GPSupportedPerfins ()
@property (weak, nonatomic) IBOutlet NSArrayController * perfinsController;
@property (weak, nonatomic) IBOutlet NSArrayController * perfinCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altPerfinCatalogNumsController;

@property (weak, nonatomic) IBOutlet NSTableView *perfinsTable;
@property (weak, nonatomic) IBOutlet NSPopover * numbersPopover;
@end

@implementation GPSupportedPerfins

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *perfinSort = [[NSSortDescriptor alloc] initWithKey:@"gp_perfin_number" ascending:YES];
        _perfinSortDescriptors = @[perfinSort];
        
        NSSortDescriptor *perfinCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _perfinCatalogSortDescriptors = @[perfinCatalogSort];
        
        NSSortDescriptor *nameSort = [[NSSortDescriptor alloc] initWithKey:@"catalogName.name" ascending:YES];
        NSSortDescriptor *numberSort = [[NSSortDescriptor alloc] initWithKey:@"perfin_catalog_number" ascending:YES];
        _altCatalogsSortDescriptors = @[nameSort, numberSort];
    }
    
    return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Perfins";
}

- (IBAction)addPicture:(id)sender {
    NSInteger selectedRow = [self.perfinsTable rowForView:sender];
    
    Perfin * perfin = self.perfinsController.arrangedObjects[selectedRow];
    
    GPDocument * doc = self.document;
    NSString * fileName = [doc addImageToWrapperUsingGPID:perfin.gp_perfin_number forAttribute:@"Perfin.picture"];
    if (fileName == nil) return;
    
    perfin.picture = fileName;
}

- (IBAction)openPopover:(NSButton *)sender {
    NSInteger selectedRow = [self.perfinsTable rowForView:sender];
    
    // Set the selected perfin for the popover to save changes into.
    self.selectedPerfin = self.perfinsController.arrangedObjects[selectedRow];
    
    [self.numbersPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:selectedRow];
}

- (IBAction)addPerfin:(id)sender {
    [self.perfinsController insert:self];
    [self.managedObjectContext save:nil];
}

- (IBAction)deletePerfin:(id)sender {
    [self.perfinsController remove:self];
    
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

- (IBAction)addAltPerfinCatalogNumber:(id)sender {
    [self.altPerfinCatalogNumsController add:sender];
}

- (IBAction)deleteAltPerfinCatalogNumber:(id)sender {
    [self.altPerfinCatalogNumsController remove:sender];
}

@end
