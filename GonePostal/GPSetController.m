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
        
        NSSortDescriptor *gpCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[gpCatalogSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_name" ascending:YES];
        self.countrySortDescriptors = @[countrySort];
        
        NSSortDescriptor *sectionSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.sectionSortDescriptors = @[sectionSort];
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
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeSet:(id)sender {
    [self.gpCatalogSetsController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeCatalogEntries:(id)sender {
    [self.gpCatalogsController removeObjects:self.gpCatalogsController.selectedObjects];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
