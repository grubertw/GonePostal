//
//  GPStampViewer.m
//  GonePostal
//
//  Created by Travis Gruber on 3/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampViewer.h"
#import "Stamp.h"
#import "GPAddStampController.h"
#import "GPDocument.h"
#import "GPCountrySearch.h"
#import "GPSectionSearch.h"
#import "GPFormatSearch.h"
#import "GPLocationSearch.h"
#import "GPChildStampItem.h"
#import "GPParentStampItem.h"

@implementation MyStamps
- (NSCollectionViewItem *)newItemForRepresentedObject:(id)object {
    Stamp * stamp = (Stamp *)object;
    
    // If the stamp has chilren, use the parent cell.
    if ([stamp.children count] == 0) {
        GPChildStampItem * childCVItem = [[GPChildStampItem alloc] initWithNibName:@"GPChildStampItem" bundle:nil];
        [childCVItem setRepresentedObject:stamp];
        return childCVItem;
    }
    // else use the child cell.
    else {
        GPParentStampItem * parentCVItem = [[GPParentStampItem alloc] initWithNibName:@"GPParentStampItem" bundle:nil];
        [parentCVItem setRepresentedObject:stamp];
        return parentCVItem;
    }
}
@end



@interface GPStampViewer ()
@property (strong, nonatomic) GPCountrySearch * countrySearchController;
@property (strong, nonatomic) GPSectionSearch * sectionSearchController;
@property (strong, nonatomic) GPFormatSearch * formatSearchController;
@property (strong, nonatomic) GPLocationSearch * locationSearchController;

@property (weak, nonatomic) IBOutlet MyStamps * stampCollectionView;
@property (weak, nonatomic) IBOutlet NSArrayController * stampsController;
@end

@implementation GPStampViewer

- (void)updateCurrentSearch {
    // Clear the present search and rebuild from scratch
    // All persisted info about the search should be loaded
    // into the three predicates at this point.
    NSMutableArray * predicateArray = [NSMutableArray arrayWithCapacity:4];
        
    if (self.countrySearchController.predicate != nil) {
        [predicateArray addObject:self.countrySearchController.predicate];
    }
    
    if (self.sectionSearchController.predicate != nil) {
        [predicateArray addObject:self.sectionSearchController.predicate];
    }
    
    if (self.formatSearchController.predicate != nil) {
        [predicateArray addObject:self.formatSearchController.predicate];
    }
    
    if (self.locationSearchController.predicate != nil) {
        [predicateArray addObject:self.locationSearchController.predicate];
    }
    
    // If there is only one element in the array,
    // a compound predicate isn't needed.
    if (predicateArray.count == 1) {
        self.assistedSearch.predicate = [predicateArray objectAtIndex:0];
    }
    else {
        // AND together predicates into a compound predicate.
        self.assistedSearch.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicateArray];
    }
    
    [self.document saveInPlace];
    
    // refilter the stamp Data.
    [self refilterStamps];
}

- (id)initWithCollection:(GPCollection *)myCollection assistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate formatSearch:(NSPredicate *)formatsPredicate locationSearch:(NSPredicate *)locationsPredicate {
    
    self = [super initWithWindowNibName:@"GPStampViewer"];
    if (self) {
        _myCollection = myCollection;
        _managedObjectContext = myCollection.managedObjectContext;
        
        _assistedSearch = assistedSearch;
        _countriesPredicate = countriesPredicate;
        _sectionsPredicate = sectionsPredicate;
        _formatsPredicate = formatsPredicate;
        _locationsPredicate = locationsPredicate;
        
        NSSortDescriptor *stampSort = [[NSSortDescriptor alloc] initWithKey:@"gpCatalog.gp_catalog_number" ascending:YES];
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _stampSortDescriptors = @[stampSort, formatSort];
        
        // Initialize the assisted search panels.
        _countrySearchController = [[GPCountrySearch alloc] initWithPredicate:countriesPredicate forStamp:YES];
        _sectionSearchController = [[GPSectionSearch alloc] initWithPredicate:sectionsPredicate forStamp:YES];
        _formatSearchController = [[GPFormatSearch alloc] initWithPredicate:formatsPredicate];
        _locationSearchController = [[GPLocationSearch alloc] initWithPredicate:locationsPredicate];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    NSSize minSize;
    minSize.height = 116;
    minSize.width = 985;
    [self.stampCollectionView setMinItemSize:minSize];
    
    // Place the AssistedSearch views into panels which will be launched as sheets.
    self.countrySearchController.panel = [[NSPanel alloc] initWithContentRect:self.countrySearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.countrySearchController.panel setContentView:self.countrySearchController.view];
    
    self.sectionSearchController.panel = [[NSPanel alloc] initWithContentRect:self.sectionSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.sectionSearchController.panel setContentView:self.sectionSearchController.view];
    
    self.formatSearchController.panel = [[NSPanel alloc] initWithContentRect:self.formatSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.formatSearchController.panel setContentView:self.formatSearchController.view];
    
    self.locationSearchController.panel = [[NSPanel alloc] initWithContentRect:self.locationSearchController.view.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.locationSearchController.panel setContentView:self.locationSearchController.view];
    
    // Fetch the stamps, based on the parsed predicate information performed
    // by the search controllers.
    [self refilterStamps];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return self.myCollection.name;
}

- (void)refilterStamps {
    [self.stampsController setFilterPredicate:self.assistedSearch.predicate];
    [self.stampsController rearrangeObjects];
}

- (IBAction)openAddFromGPCatalog:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.myCollection operatingMode:2];
    
    GPDocument * doc = self.document;
    [doc addWindowController:addStampController];
    [addStampController.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddCompositeEditor:(id)sender {
    
}

- (IBAction)openAddSetChooser:(id)sender {
    
}

- (IBAction)openLocator:(id)sender {
    GPAddStampController * addStampController = [[GPAddStampController alloc] initWithCollection:self.myCollection operatingMode:1];
    
    [self.document addWindowController:addStampController];
    [addStampController.window makeKeyAndOrderFront:self];
}

- (IBAction)openCountriesSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.countrySearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openSectionsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.sectionSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openFormatsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.formatSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (IBAction)openLocationsSearchPanel:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    
    [app beginSheet:self.locationSearchController.panel modalForWindow:self.window modalDelegate:self didEndSelector:@selector(sheetDidEnd:returnCode:contextInfo:) contextInfo:nil];
}

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(NSInteger)returnCode contextInfo:(void *)contextInfo {
    [self updateCurrentSearch];
}

- (IBAction)closeChildren:(id)sender {
    
}

- (IBAction)deleteStamp:(id)sender {
    [self.stampsController remove:sender];
}

@end
