//
//  GPAlbumSizeController.m
//  GonePostal
//
//  Created by Travis Gruber on 1/3/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import "GPAlbumSizeController.h"
#import "GonePostal-Swift.h"

@interface GPAlbumSizeController ()

@end

@implementation GPAlbumSizeController

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
