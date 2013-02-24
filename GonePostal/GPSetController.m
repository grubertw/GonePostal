//
//  GPSetController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/13/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSetController.h"

@interface GPSetController ()

@end

@implementation GPSetController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *setSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.gpCatalogSetsSortDescriptors = @[setSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Catalog Sets";
}

- (IBAction)addSet:(id)sender {
    [self.gpCatalogSetsController insert:sender];
}

- (IBAction)removeSet:(id)sender {
    [self.gpCatalogSetsController remove:sender];
}

- (IBAction)removeCatalogEntries:(id)sender {
    [self.gpCatalogsController removeObjects:self.gpCatalogsController.selectedObjects];
}

@end
