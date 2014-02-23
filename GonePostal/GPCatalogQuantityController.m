//
//  GPCatalogQuantityController.m
//  GonePostal
//
//  Created by Travis Gruber on 2/23/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPCatalogQuantityController.h"
#import "GPDocument.h"

@interface GPCatalogQuantityController ()

@end

@implementation GPCatalogQuantityController

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
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sortDescriptors = @[sort];
    }
    return self;
}

@end
