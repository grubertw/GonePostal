//
//  GPCatalogEditor.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogEditor.h"
#import "GPDocument.h"
#import "GPAddToCatalogController.h"
#import "GPAddSubvariety.h"
#import "GPCatalog+Duplicate.h"
#import "GPCatalogSet.h"
#import "GPSetController.h"
#import "PlateUsage.h"
#import "PlateNumber.h"
#import "GPPlateUsageController.h"
#import "Cachet.h"
#import "LooksLike.h"
#import "GPLooksLikeController.h"

@interface GPCatalogEditor ()

@end

@implementation GPCatalogEditor


- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *gpCountrySort = [[NSSortDescriptor alloc] initWithKey:@"country.country_sort_id" ascending:YES];
        NSSortDescriptor *groupSort = [[NSSortDescriptor alloc] initWithKey:@"catalogGroup.group_number" ascending:YES];
        NSSortDescriptor *catalogNumberSort = [[NSSortDescriptor alloc] initWithKey:@"gp_catalog_number" ascending:YES];
        self.gpCatalogEntriesSortDescriptors = @[gpCountrySort, groupSort, catalogNumberSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        self.countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"formatName" ascending:YES];
        self.formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *altCatalogNameSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        self.altCatalogNamesSortDescriptors = @[altCatalogNameSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        self.gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternateCatalogName.alternate_catalog_name" ascending:YES];
        self.altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *gpSetSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.gpCatalogSetsSortDescriptors = @[gpSetSort];
        
        NSSortDescriptor *plateUsageSort = [[NSSortDescriptor alloc] initWithKey:@"plate_number" ascending:YES];
        self.plateUsageSortDescriptors = @[plateUsageSort];
        
        NSSortDescriptor *plateNumber1Sort = [[NSSortDescriptor alloc] initWithKey:@"plate1" ascending:YES];
        NSSortDescriptor *plateNumber2Sort = [[NSSortDescriptor alloc] initWithKey:@"plate2" ascending:YES];
        self.plateNumberSortDescriptors = @[plateNumber1Sort, plateNumber2Sort];
        
        NSSortDescriptor *cachetSort = [[NSSortDescriptor alloc] initWithKey:@"gp_cachet_number" ascending:YES];
        self.cachetSortDescriptors = @[cachetSort];
        
        NSSortDescriptor *looksLikeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.looksLikeSortDescriptors = @[looksLikeSort];
        
        self.baseGPCatalogFilter = [NSPredicate predicateWithFormat:@"majorVariety == NIL"];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self.identScroller setDocumentView:self.identScrollContent];
    [self.infoScroller setDocumentView:self.infoScrollContent];
    [self.platesScroller setDocumentView:self.platesScrollContent];
    
    // Set the scrollers to the top.
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.identScroller documentView] frame]) -
                                    [[self.identScroller contentView] bounds].size.height);
    [[self.identScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.infoScroller documentView] frame]) -
                                    [[self.infoScroller contentView] bounds].size.height);
    [[self.infoScroller documentView] scrollPoint:newOrigin];
    
    newOrigin = NSMakePoint(0, NSMaxY([[self.platesScroller documentView] frame]) -
                                    [[self.platesScroller contentView] bounds].size.height);
    [[self.platesScroller documentView] scrollPoint:newOrigin];
    
    // Create a panel used to help the user select a set.
    self.addToSetPanel = [[NSPanel alloc] initWithContentRect:self.addToSetSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToSetPanel setContentView:self.addToSetSelector];
    
    // Create a panel to help user select a looks like.
    self.addToLooksLikePanel = [[NSPanel alloc] initWithContentRect:self.addToLooksLikeSelector.bounds styleMask:NSTexturedBackgroundWindowMask backing:NSBackingStoreBuffered defer:YES];
    [self.addToLooksLikePanel setContentView:self.addToLooksLikeSelector];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"GP Catalog Editor";
}

- (IBAction)openAddToGPCatalog:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPAddToCatalogController * controller = [[GPAddToCatalogController alloc] initWithWindowNibName:@"GPAddToCatalogController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)openAddSubvariety:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    GPCatalog * entry = nil;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * possibleEntry = [entries objectAtIndex:0];
        // Only allow creation of subvarieties on top-level major varieties.
        if (possibleEntry.majorVariety == nil) {
            entry = possibleEntry;
        }
        else {
            // If this is clicked from the subvarieties screen, add another
            // subvariety to the major variety of the selected entry.
            entry = possibleEntry.majorVariety;
        }
    }
    
    if (entry == nil) return;
    
    GPAddSubvariety * controller = [[GPAddSubvariety alloc] initWithWindowNibName:@"GPAddSubvariety"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    [controller setTheMajorVariety:entry];
    
    [controller.window makeKeyAndOrderFront:self];
}

- (IBAction)duplicateGPCatalogEntry:(id)sender {
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    
    for (NSUInteger i=0; i<entries.count; i++) {
        GPCatalog * entry = [entries objectAtIndex:i];
        [entry duplicateFromThis];
    }
}

- (IBAction)removeSelectedGPCatalogEntries:(id)sender {
    [self.gpCatalogEntriesController remove:self];
}

- (IBAction)addToGPCatalogSet:(id)sender {
    // Run the add to set panel as a sheet on top of the catalog editor.
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToSetPanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToSet:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
 
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        NSArray * setList = [self.gpCatalogSetsController arrangedObjects];
        if (setList == nil) return;
        
        NSInteger selectedSetIndex = self.setSelectorCombo.indexOfSelectedItem;
        if (selectedSetIndex == -1) return;
        
        GPCatalogSet * catalogSet = [setList objectAtIndex:selectedSetIndex];
        [catalogSet addGpCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];        
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToSetPanel];
    [self.addToSetPanel close];
}

- (IBAction)addToLooksLike:(id)sender {
    NSApplication * app = [NSApplication sharedApplication];
    [app beginSheet:self.addToLooksLikePanel modalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
}

- (IBAction)addSelectedEntriesToLooksLike:(id)sender {
    NSInteger tag = ((NSButton *)sender).tag;
    
    if (tag == 1) {
        NSArray * selectedGPCatalogEntries = self.gpCatalogEntriesController.selectedObjects;
        if (selectedGPCatalogEntries == nil) return;
        
        LooksLike * ll;
        NSArray * selectedLooksLike = self.looksLikeController.selectedObjects;
        if (selectedLooksLike == nil) return;
        
        ll = [selectedLooksLike objectAtIndex:0];
        if (ll == nil) return;
        
        [ll addTheseGPCatalogEntries:[NSSet setWithArray:selectedGPCatalogEntries]];
    }
    
    // End the sheet.
    NSApplication * app = [NSApplication sharedApplication];
    [app endSheet:self.addToLooksLikePanel];
    [self.addToLooksLikePanel close];
}

- (IBAction)manageSets:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPSetController * controller = [[GPSetController alloc] initWithWindowNibName:@"GPSetController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)manageLooksLike:(id)sender {
    GPDocument * doc = (GPDocument *)self.document;
    
    GPLooksLikeController * controller = [[GPLooksLikeController alloc] initWithWindowNibName:@"GPLooksLikeController"];
    [doc addWindowController:controller];
    [controller setManagedObjectContext:self.managedObjectContext];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)viewSubvarieties:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    // Save the query in current operation for restoration.
    self.lastViewedQuery = self.gpCatalogEntriesController.filterPredicate;
    
    GPCatalog * theMajorVariety = nil;
    NSArray * selectedObjects = self.gpCatalogEntriesController.selectedObjects;
    if (selectedObjects != nil)
        theMajorVariety = [selectedObjects objectAtIndex:0];
    
    if (theMajorVariety != nil && (theMajorVariety.subvarieties.count > 0)) {
        NSPredicate *query = [NSPredicate predicateWithFormat:@"majorVariety.gp_catalog_number like %@", theMajorVariety.gp_catalog_number];
        
        [self.gpCatalogEntriesController setFilterPredicate:query];
        [self.gpCatalogEntriesController rearrangeObjects];
        
        // Set the selection to the first subvariety.
        [self.gpCatalogEntriesController setSelectionIndex:0];
    }
}

- (IBAction)closeSubvarieties:(id)sender {
    // Get the major variety from the selection.
    GPCatalog * theMajorVariety = nil;
    NSArray * selectedObjects = self.gpCatalogEntriesController.selectedObjects;
    if (selectedObjects != nil) {
        GPCatalog * entry = [selectedObjects objectAtIndex:0];
        theMajorVariety = entry.majorVariety;
    }
    
    // Restore the previous filter
    [self.gpCatalogEntriesController setFilterPredicate:self.lastViewedQuery];
    [self.gpCatalogEntriesController rearrangeObjects];
    
    [self.gpCatalogEntriesController setSelectedObjects:@[theMajorVariety]];
    
    // Make sure the selection is visable.
    NSUInteger selRow = self.gpCatalogEntriesController.selectionIndex;
    [self.gpCatalogTable scrollRowToVisible:selRow];
}

- (IBAction)viewSetsForGPCatalogEntry:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    NSButton * llButton = (NSButton *)sender;
    
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    if (selectedEntries == nil) return;
    
    GPCatalog * selectedEntry = [selectedEntries objectAtIndex:0];
    [self.setsPopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.setsPopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)viewLooksLikeForGPCatalogEntry:(id)sender {
    if (   ([self.gpCatalogTable rowForView:sender] != self.gpCatalogTable.selectedRow)
        || (self.gpCatalogEntriesController.selectedObjects.count != 1))
        return;
    
    NSButton * llButton = (NSButton *)sender;
    
    NSArray * selectedEntries = self.gpCatalogEntriesController.selectedObjects;
    if (selectedEntries == nil) return;
    
    GPCatalog * selectedEntry = [selectedEntries objectAtIndex:0];
    [self.looksLikePopoverController setSelectedCatalogEntry:selectedEntry];
    
    [self.looksLikePopover showRelativeToRect:llButton.bounds ofView:sender preferredEdge:self.gpCatalogTable.selectedRow];
}

- (IBAction)addAlternateCatalog:(id)sender {
    [self.altCatalogsController add:self];
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.default_picture = fileName;
    }
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_1 = fileName;
      }
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_2 = fileName;
    }
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_3 = fileName;
    }
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_4 = fileName;
    }
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_5 = fileName;
    }
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.document addPictureToWrapper];
    if (fileName == nil) return;
    
    // Store the filename into the model.
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries.count > 0) {
        GPCatalog * entry = [entries objectAtIndex:0];
        entry.alternate_picture_6 = fileName;
    }
}

- (IBAction)addPlateUsage:(id)sender {
    PlateUsage * pu = [NSEntityDescription insertNewObjectForEntityForName:@"PlateUsage" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    // Increment the plate_number based on number of plate usages present.
    NSUInteger nextPlateNumber = entry.plateUsage.count + 1;
    [pu setPlate_number:[NSNumber numberWithUnsignedInteger:nextPlateNumber]];
    
    [entry addPlateUsageObject:pu];
}

- (IBAction)removePlateUsage:(id)sender {
    NSArray * selectedPlateUsages = self.plateUsageController.selectedObjects;
    if (selectedPlateUsages == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateUsage:[NSSet setWithArray:selectedPlateUsages]];
}

- (IBAction)addPlateNumberCombination:(id)sender {
    PlateNumber * pn = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addPlateNumbersObject:pn];
}

- (IBAction)removePlateNumberCombination:(id)sender {
    NSArray * selectedPlateNumbers = self.plateNumberCombinationsController.selectedObjects;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removePlateNumbers:[NSSet setWithArray:selectedPlateNumbers]];
}

- (IBAction)addCachet:(id)sender {
    Cachet * cachet = [NSEntityDescription insertNewObjectForEntityForName:@"Cachet" inManagedObjectContext:self.managedObjectContext];
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry addCachetsObject:cachet];
}

- (IBAction)removeCachet:(id)sender {
    NSArray * selectedCachets = self.cachetController.selectedObjects;
    if (selectedCachets == nil) return;
    
    NSArray * entries = self.gpCatalogEntriesController.selectedObjects;
    if (entries == nil) return;
    GPCatalog * entry = [entries objectAtIndex:0];
    
    [entry removeCachets:[NSSet setWithArray:selectedCachets]];
}

@end
