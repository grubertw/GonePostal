//
//  GPBureauPrecancelChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPBureauPrecancelChooser.h"
#import "BureauPrecancel.h"

@interface GPBureauPrecancelChooser ()
@property (nonatomic) BOOL isSheet;

@property (strong, nonatomic) IBOutlet NSArrayController *bureauPrecancelController;
@end

@implementation GPBureauPrecancelChooser

- (id)initAsSheet:(BOOL)isSheet modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPBureauPrecancelChooser" bundle:nil];
    if (self) {
        _isSheet = isSheet;
        
        // Initialize the sort descriptors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"gp_precancel_number" ascending:YES];
        _sortDescriptors = @[sort];
        
        _managedObjectContext = stamp.managedObjectContext;
        _stamp = stamp;
    }
    
    return self;
}

- (IBAction)closeChooser:(id)sender {
    if ([self.bureauPrecancelController.selectedObjects count] > 0) {
        self.stamp.bureauPrecancel = self.bureauPrecancelController.selectedObjects[0];
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
