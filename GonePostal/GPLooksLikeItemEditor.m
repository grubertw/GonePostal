//
//  GPLooksLikeItemEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLooksLikeItemEditor.h"
#import "LooksLike.h"
#import "GPCatalogPictureSelector.h"
#import "GonePostal-Swift.h"

@interface GPLooksLikeItemEditor ()

@property (strong, nonatomic) GPDocument * doc;

@end

@implementation GPLooksLikeItemEditor

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        self.managedObjectContext = _doc.managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        self.managedObjectContext = _doc.managedObjectContext;
        
        // Create the sort descripors
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_name" ascending:YES];
        self.countrySortDescriptors = @[countrySort];
        
        NSSortDescriptor *sectionSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.sectionSortDescriptors = @[sectionSort];
        
        NSSortDescriptor *salesGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _salesGroupSortDescriptors = @[salesGroupSort];
    }
    
    return self;
}

- (IBAction)addPicture:(id)sender {
    LooksLike * ll = self.looksLikeController.content;
    
    NSString * llName = [NSString stringWithFormat:@"looksLike %@", ll.name];
    
    NSString * fileName = [self.doc addImageToWrapperUsingGPID:llName forAttribute:@"LooksLike.picture"];
    if (fileName == nil) return;
    
    ll.picture = fileName;
}

- (IBAction)addPictureFromCatalog:(id)sender {
    LooksLike * ll = self.looksLikeController.content;
        
    [self.doc loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
    
    GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:self.doc.assistedSearch countrySearch:self.doc.countriesPredicate sectionSearch:self.doc.sectionsPredicate filterSearch:self.doc.filtersPredicate targetAttributeName:@"LooksLike.picture" selectingPicture:YES];
    [controller setTargetLooksLike:ll];
    
    [self.doc addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
    
}

- (IBAction)removePicture:(id)sender {
    LooksLike * ll = self.looksLikeController.content;
    ll.picture = @"empty";
}

- (IBAction)addCatalogEntries:(id)sender {
    LooksLike * ll = self.looksLikeController.content;
    
    [self.doc loadAssistedSearch:GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID];
    
    GPCatalogPictureSelector * controller = [[GPCatalogPictureSelector alloc] initWithAssistedSearch:self.doc.assistedSearch countrySearch:self.doc.countriesPredicate sectionSearch:self.doc.sectionsPredicate filterSearch:self.doc.filtersPredicate targetAttributeName:@"LooksLike.picture" selectingPicture:NO];
    [controller setTargetLooksLike:ll];
    
    [self.doc addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)removeCatalogEntries:(id)sender {
    NSArray * selectedGPCatalogEntries = self.gpCatalogsController.selectedObjects;
    
    LooksLike * ll = self.looksLikeController.content;
    [ll removeTheseGPCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.view.window completionHandler:nil];
        [self.managedObjectContext undo];
    }
}

@end
