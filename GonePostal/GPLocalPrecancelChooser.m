//
//  GPLocalPrecancelChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLocalPrecancelChooser.h"
#import "GPDocument.h"
#import "LocalPrecancel.h"

@interface GPLocalPrecancelChooser ()
@property (nonatomic) BOOL isSheet;

@property (strong, nonatomic) IBOutlet NSArrayController *localPrecancelController;
@end

@implementation GPLocalPrecancelChooser

- (id)initAsSheet:(BOOL)isSheet modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPLocalPrecancelChooser" bundle:nil];
    if (self) {
        _isSheet = isSheet;
        
        // Initialize the sort descriptors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        _stamp = stamp;
    }
    
    return self;
}

- (IBAction)closeChooser:(id)sender {
    if ([self.localPrecancelController.selectedObjects count] > 0) {
        self.stamp.localPrecancel = self.localPrecancelController.selectedObjects[0];
    }
    
    if (self.isSheet) {
        // End the sheet.
        NSApplication * app = [NSApplication sharedApplication];
        [app endSheet:self.view.window];
        [self.view.window close];
    }
}

@end
