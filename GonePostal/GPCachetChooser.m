//
//  GPCachetChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCachetChooser.h"
#import "GPDocument.h"
#import "Cachet.h"

@interface GPCachetChooser ()
@property (nonatomic) BOOL isSheet;

@property (weak, nonatomic) IBOutlet NSArrayController * cachetController;

@property (weak, nonatomic) IBOutlet NSTableView * cachetTable;
@property (weak, nonatomic) IBOutlet NSPopover * morePicturesPopover;
@property (weak, nonatomic) IBOutlet NSViewController * morePicturesController;
@end

@implementation GPCachetChooser

- (id)initAsSheet:(BOOL)isSheet modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPCachetChooser" bundle:nil];
    if (self) {
        _isSheet = isSheet;
        
        // Initialize the sort descriptors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_cachet_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        _managedObjectContext = stamp.managedObjectContext;
        _stamp = stamp;
    }
    
    return self;
}

- (IBAction)viewMorePictures:(id)sender {
    NSButton * button = (NSButton *)sender;
    NSInteger row = [self.cachetTable rowForView:button];
    
    // Set the represented object in the view controller
    Cachet * selectedCachet = self.cachetController.arrangedObjects[row];
    [self.morePicturesController setRepresentedObject:selectedCachet];
    
    // Display the popup over the correct button in the table.
    [self.morePicturesPopover showRelativeToRect:button.bounds ofView:sender preferredEdge:row];
}

- (IBAction)closeChooser:(id)sender {
    if ([self.cachetController.selectedObjects count] > 0) {
        self.stamp.cachet = self.cachetController.selectedObjects[0];
    }
    
    if (self.isSheet) {
        // End the sheet.
        NSApplication * app = [NSApplication sharedApplication];
        [app endSheet:self.view.window];
        [self.view.window close];
    }
    else {
        [self.drawer close];
    }
}

@end
