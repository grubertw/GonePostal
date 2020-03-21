//
//  GPPerfinChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPerfinChooser.h"
#import "Perfin.h"
#import "GonePostal-Swift.h"

@interface GPPerfinChooser ()
@property (nonatomic) BOOL isDrawer;

@property (strong, nonatomic) IBOutlet NSArrayController *perfinController;
@property (strong, nonatomic) IBOutlet NSArrayController *perfinCatalogController;

@property (weak, nonatomic) IBOutlet NSTableView *perfinTable;
@property (weak, nonatomic) IBOutlet NSViewController *altPerfinsViewController;
@property (weak, nonatomic) IBOutlet NSPopover *altPerfinsPopover;
@end

@implementation GPPerfinChooser

- (id)initAsDrawer:(BOOL)isDrawer modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPPerfinChooser" bundle:nil];
    if (self) {
        _isDrawer = isDrawer;
        
        // Initialize the sort descriptors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_perfin_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSSortDescriptor *catalogSort = [[NSSortDescriptor alloc] initWithKey:@"catalogName.name" ascending:YES];
        NSSortDescriptor *numberSort = [[NSSortDescriptor alloc] initWithKey:@"perfin_catalog_number" ascending:YES];
        _catalogSortDescriptors = @[catalogSort, numberSort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        _stamp = stamp;
    }
    
    return self;
}

- (IBAction)viewAltCatalogs:(NSButton *)sender {
    NSInteger row = [self.perfinTable rowForView:sender];
    Perfin * selectedPerfin = self.perfinController.arrangedObjects[row];
    
    [self.perfinCatalogController setContent:selectedPerfin.alternateCatalogs];
    [self.altPerfinsPopover showRelativeToRect:sender.bounds ofView:sender preferredEdge:row];
}

- (IBAction)closeChooser:(id)sender {
    if ([self.perfinController.selectedObjects count] > 0) {
        self.stamp.perfin = self.perfinController.selectedObjects[0];
    }
    
    if (self.isDrawer) {
        [self.drawer close];
    }
    else {
        [self.view removeFromSuperview];
    }
}

@end
