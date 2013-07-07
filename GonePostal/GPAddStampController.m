//
//  GPAddStampController.m
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAddStampController.h"
#import "GPDocument.h"
#import "GPCatalog.h"
#import "Stamp+Create.h"

@interface GPAddStampController ()
@property (nonatomic) NSUInteger operatingMode;

@property (weak, nonatomic) IBOutlet NSPageController * pageController;
@property (weak, nonatomic) IBOutlet NSTextField * pageDescription;
@property (weak, nonatomic) IBOutlet NSButton * forwardButton;
@property (weak, nonatomic) IBOutlet NSButton * backButton;
@property (weak, nonatomic) IBOutlet NSButton * doneButton;

@property (strong, nonatomic) NSArray * pages;
@property (assign) id initialSelectedPage;

@property (nonatomic) BOOL savePressed;
@end

static const NSUInteger LOCATOR_PAGE = 1;
static const NSUInteger GP_CATALOG_PAGE = 2;
static const NSUInteger NEW_STAMP_PAGE = 3;

static NSString * LOCATOR_PAGE_TITLE = @"Choose a Stamp Locator";
static NSString * GP_CATALOG_PAGE_TITLE = @"Choose a Stamp From the Catalog";
static NSString * NEW_STAMP_PAGE_TITLE = @"Specify Stamp Specifics";

@implementation GPAddStampController

- (id)initWithCollection:(GPCollection *)myCollection operatingMode:(NSUInteger)mode {
    self = [super initWithWindowNibName:@"GPAddStampController"];
    if (self) {
        _myCollection = myCollection;
        _operatingMode = mode;
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        
        _managedObjectContext = self.myCollection.managedObjectContext;
        _savePressed = NO;
        
        if (mode == 1) {
            // Instantiate and initilize all three wizard pages.
            [doc loadAssistedSearch:ASSISTED_LOOKS_LIKE_BROWSER_SEARCH_ID];
            _gpLocatorPage = [[GPLocatorPage alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate];
            
            // If the locator is being used, clear the catalog browser search in favor
            // of the LooksLike.
            [doc loadAssistedSearch:ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID];
            doc.assistedSearch.predicate = nil;
            
            _gpCatalogPage = [[GPCatalogChooserPage alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:nil sectionSearch:nil filterSearch:nil parentController:self];
            
            _gpNewStampPage = [[GPNewStampPage alloc] initWithCollection:myCollection];
            [_gpNewStampPage setComposite:self.composite];
            
            _pages = @[@(LOCATOR_PAGE),@(GP_CATALOG_PAGE),@(NEW_STAMP_PAGE)];
        }
        else if (mode == 2) {
            // Instantiate the catalog chooser page and new stamp page.
            [doc loadAssistedSearch:ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID];
            
            _gpCatalogPage = [[GPCatalogChooserPage alloc] initWithAssistedSearch:doc.assistedSearch countrySearch:doc.countriesPredicate sectionSearch:doc.sectionsPredicate filterSearch:doc.filtersPredicate parentController:self];
            
            _gpNewStampPage = [[GPNewStampPage alloc] initWithCollection:myCollection];
            [_gpNewStampPage setComposite:self.composite];
            
            _pages = @[@(GP_CATALOG_PAGE), @(NEW_STAMP_PAGE)];
            _initialSelectedPage = @(GP_CATALOG_PAGE);
        }
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Initialize the page controller
    [self.pageController setArrangedObjects:self.pages];
    [self.pageController setSelectedIndex:0];
    
    if (self.operatingMode == 1) {
        [self.pageDescription setStringValue:LOCATOR_PAGE_TITLE];
    }
    else if (self.operatingMode == 2) {
        [self.pageDescription setStringValue:GP_CATALOG_PAGE_TITLE];
    }
    
    [self.backButton setHidden:YES];
    [self.forwardButton setHidden:NO];
}

- (void)setSelectedGPCatalog:(GPCatalog *)selectedGPCatalog {
    _selectedGPCatalog = selectedGPCatalog;
    [self.gpNewStampPage setSelectedGPCatalog:selectedGPCatalog];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.myCollection.name;
}

- (NSString *)pageController:(NSPageController *)pageController identifierForObject:(id)object {
    NSString * rc;
    if ([object isEqualToNumber:@(LOCATOR_PAGE)]) {
        rc = @"GPLocatorPage";
    }
    else if ([object isEqualToNumber:@(GP_CATALOG_PAGE)]) {
        rc = @"GPCatalogChooserPage";
    }
    else if ([object isEqualToNumber:@(NEW_STAMP_PAGE)]) {
        rc = @"GPNewStampPage";
    }
    
    return rc;
}

- (NSViewController *)pageController:(NSPageController *)pageController viewControllerForIdentifier:(NSString *)identifier {
    if ([identifier isEqualToString:@"GPLocatorPage"]) {
        return self.gpLocatorPage;
    }
    else if ([identifier isEqualToString:@"GPCatalogChooserPage"]) {
        return self.gpCatalogPage;
    }
    else if ([identifier isEqualToString:@"GPNewStampPage"]) {
        return self.gpNewStampPage;
    }
    
    return nil;
}

-(void)pageController:(NSPageController *)pageController prepareViewController:(NSViewController *)viewController withObject:(id)object {
    // If the passed in object is the initial selected page, this is a cancel.
    if (self.initialSelectedPage && self.initialSelectedPage == object) return;
}

- (void)pageControllerWillStartLiveTransition:(NSPageController *)pageController {
    // Remember the initial selected object so we can determine when a cancel occurred.
    self.initialSelectedPage = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
    
    // Capture any selection the user has made.
    if (self.gpLocatorPage) {
        self.selectedLooksLike = self.gpLocatorPage.looksLikeController.selectedObjects[0];
    }
}

- (void)pageControllerDidEndLiveTransition:(NSPageController *)pageController {
    [pageController completeTransition];
    id selectedPage = [pageController.arrangedObjects objectAtIndex:pageController.selectedIndex];
    
    if ([selectedPage isEqualToNumber:@(LOCATOR_PAGE)]) {
        [self.backButton setHidden:YES];
    }
    else if ([selectedPage isEqualToNumber:@(GP_CATALOG_PAGE)]) {
        if (self.gpLocatorPage) {
            // If this is a transition from the GPLocator, load the catalog chooser
            // with the selectedLooksLike
            [self.gpCatalogPage setSelectedLooksLike:self.selectedLooksLike];
        }
        
        [self.pageDescription setStringValue:GP_CATALOG_PAGE_TITLE];
        
        if (self.operatingMode == 2)
            [self.backButton setHidden:YES];
        else
            [self.backButton setHidden:NO];
        
        [self.forwardButton setHidden:NO];
    }
    else if ([selectedPage isEqualToNumber:@(NEW_STAMP_PAGE)]) {
        [self.pageDescription setStringValue:NEW_STAMP_PAGE_TITLE];
        
        [self.forwardButton setHidden:YES];
        [self.backButton setHidden:NO];
        
        [self.gpNewStampPage updateDynamicStampBoxes];
    }
}

- (IBAction)nextPage:(id)sender {
    [self.pageController navigateForward:sender];
}

- (IBAction)prevPage:(id)sender {
    [self.pageController navigateBack:sender];
}

- (IBAction)quickAdd:(id)sender {
    Stamp * stamp = [Stamp CreateFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    stamp.gpCatalog = self.gpCatalogPage.selectedGPCatalog;
    stamp.gp_stamp_number = self.gpCatalogPage.selectedGPCatalog.gp_catalog_number;
    
    if (self.composite == nil) {
        // Add the new stamp to the collection.
        [self.myCollection addStampsObject:stamp];
    }
    else {
        [self.composite addChildrenObject:stamp];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
}

- (IBAction)done:(id)sender {
    [self.gpNewStampPage addCurrentStamp];
    
    self.savePressed = YES;
    [self.window performClose:sender];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:sender];
}

- (void)windowWillClose:(NSNotification *)notification {
    if (!self.savePressed) {
        // Rollback all changed to the managed object context
        // that have not been explicitly saved.
        [self.managedObjectContext rollback];
    }
    
    [self.gpNewStampPage cleanup];
}

@end
