//
//  GPCatalogDateController.m
//  GonePostal
//
//  Created by Travis Gruber on 2/21/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPCatalogDateController.h"
#import "GonePostal-Swift.h"

@interface GPCatalogDateController ()
@end

@implementation GPCatalogDateController

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
        
        NSSortDescriptor *gpCatalogDateTypeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _gpCatalogDateTypeSortDescriptors = @[gpCatalogDateTypeSort];
    }
    return self;
}

@end
