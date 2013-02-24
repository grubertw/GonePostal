//
//  GPSetPopoverController.m
//  GonePostal
//
//  Created by Travis Gruber on 2/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSetPopoverController.h"
#import "GPDocument.h"

@interface GPSetPopoverController ()

@end

@implementation GPSetPopoverController

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
        
        NSSortDescriptor *gpSetSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.setsSortDescriptors = @[gpSetSort];
    }
    
    return self;
}

- (IBAction)addSetToGPCatalogEntry:(id)sender {
    if (self.selectedSet == nil) return;
    
    [self.selectedCatalogEntry addCatalogSetsObject:self.selectedSet];
}

- (IBAction)removeSetFromGPCatalogEntry:(id)sender {
    NSArray * selectedSets = self.setsInGPCatalogController.selectedObjects;
    if (selectedSets == nil) return;
    
    [self.selectedCatalogEntry removeCatalogSets:[NSSet setWithArray:selectedSets]];
}

@end
