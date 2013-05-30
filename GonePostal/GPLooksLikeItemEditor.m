//
//  GPLooksLikeItemEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLooksLikeItemEditor.h"
#import "GPDocument.h"
#import "LooksLike.h"

@interface GPLooksLikeItemEditor ()

@property (strong, nonatomic) GPDocument * gpDocument;

@end

@implementation GPLooksLikeItemEditor

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        [self setGpDocument:doc];
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
        [self setGpDocument:doc];
        self.managedObjectContext = doc.managedObjectContext;
        
        // Create the sort descripors
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[gpCountrySort, groupSort, catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_name" ascending:YES];
        self.countrySortDescriptors = @[countrySort];
        
        NSSortDescriptor *sectionSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.sectionSortDescriptors = @[sectionSort];
    }
    
    return self;
}

- (IBAction)addPicture:(id)sender {
    LooksLike * ll = self.looksLikeController.content;
    
    NSString * llName = [NSString stringWithFormat:@"looksLike %@", ll.name];
    
    NSString * fileName = [self.gpDocument addPictureToWrapperUsingGPID:llName forAttribute:@"picture"];
    if (fileName == nil) return;
    
    ll.picture = fileName;
}

- (IBAction)removeCatalogEntries:(id)sender {
    NSArray * selectedGPCatalogEntries = self.gpCatalogsController.selectedObjects;
    
    LooksLike * ll = self.looksLikeController.content;
    [ll removeTheseGPCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.view.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

@end
