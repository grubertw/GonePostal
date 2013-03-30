//
//  GPSupportedPerfins.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedPerfins.h"
#import "GPDocument.h"

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
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    NSInteger selectedRow = [self.perfinsTable rowForView:sender];
    
    Perfin * perfin = self.perfinsController.arrangedObjects[selectedRow];
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
}

- (IBAction)deletePerfin:(id)sender {
    [self.perfinsController remove:self];
}

- (IBAction)addAltPerfinCatalogNumber:(id)sender {
    [self.altPerfinCatalogNumsController add:sender];
}

- (IBAction)deleteAltPerfinCatalogNumber:(id)sender {
    [self.altPerfinCatalogNumsController remove:sender];
}

@end
