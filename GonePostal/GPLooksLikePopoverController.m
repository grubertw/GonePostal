//
//  GPLooksLikePopoverController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLooksLikePopoverController.h"
#import "GPDocument.h"

@interface GPLooksLikePopoverController ()
@end

@implementation GPLooksLikePopoverController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        self.managedObjectContext = doc.managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        self.managedObjectContext = doc.managedObjectContext;
    }
    
    return self;
}

- (IBAction)removeSelectedFromLooksLike:(id)sender {
    self.selectedCatalogEntry.looksLike = nil;
}

@end
