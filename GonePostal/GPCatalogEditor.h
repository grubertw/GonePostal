//
//  GPCatalogEditor.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalogSet.h"
#import "GPSetPopoverController.h"
#import "GPLooksLikePopoverController.h"
#import "Topic.h"

@interface GPCatalogEditor : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogEntriesSortDescriptors;
@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogNamesSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogSetsSortDescriptors;
@property (strong, nonatomic) NSArray * plateUsageSortDescriptors;
@property (strong, nonatomic) NSArray * plateNumberSortDescriptors;
@property (strong, nonatomic) NSArray * cachetSortDescriptors;
@property (strong, nonatomic) NSArray * looksLikeSortDescriptors;
@property (strong, nonatomic) NSArray * precancelsSortDescriptors;
@property (strong, nonatomic) NSArray * cancelationsSortDescriptors;
@property (strong, nonatomic) NSArray * topicsSortDescriptors;
@property (strong, nonatomic) NSArray * identificationPicturesSortDescriptors;

@property (strong, nonatomic) NSPredicate * baseGPCatalogFilter;

@property (strong, nonatomic) IBOutlet NSTableView * gpCatalogTable;

@property (weak, nonatomic) IBOutlet NSScrollView * identScroller;
@property (weak, nonatomic) IBOutlet NSView * identScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * infoScroller;
@property (weak, nonatomic) IBOutlet NSView * infoScrollContent;
@property (weak, nonatomic) IBOutlet NSScrollView * platesScroller;
@property (weak, nonatomic) IBOutlet NSView * platesScrollContent;
@property (weak, nonatomic) IBOutlet NSCollectionView * plateUsageCollectionView;
@property (weak, nonatomic) IBOutlet NSCollectionView * cachetCollectionView;

@property (strong, nonatomic) NSPanel * addToSetPanel;
@property (weak, nonatomic) IBOutlet NSView * addToSetSelector;
@property (weak, nonatomic) IBOutlet NSComboBox * setSelectorCombo;

@property (strong, nonatomic) NSPanel * addToLooksLikePanel;
@property (strong, nonatomic) IBOutlet NSView * addToLooksLikeSelector;

@property (weak, nonatomic) IBOutlet NSPopover * setsPopover;
@property (weak, nonatomic) IBOutlet GPSetPopoverController * setsPopoverController;

@property (weak, nonatomic) IBOutlet NSPopover * looksLikePopover;
@property (weak, nonatomic) IBOutlet GPLooksLikePopoverController * looksLikePopoverController;

@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogEntriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * countriesController;
@property (weak, nonatomic) IBOutlet NSArrayController * formatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogsController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogNamesController;
@property (weak, nonatomic) IBOutlet NSArrayController * altCatalogSectionsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpGroupsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogSetsController;
@property (weak, nonatomic) IBOutlet NSArrayController * plateUsageController;
@property (weak, nonatomic) IBOutlet NSArrayController * plateNumberCombinationsController;
@property (weak, nonatomic) IBOutlet NSArrayController * cachetController;
@property (weak, nonatomic) IBOutlet NSArrayController * looksLikeController;
@property (weak, nonatomic) IBOutlet NSArrayController * precancelsController;
@property (weak, nonatomic) IBOutlet NSArrayController * cancelationsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsController;
@property (weak, nonatomic) IBOutlet NSArrayController * topicsInGPCatalogController;
@property (weak, nonatomic) IBOutlet NSArrayController * identificationPicturesController;

- (IBAction)openAddToGPCatalog:(id)sender;
- (IBAction)openAddSubvariety:(id)sender;
- (IBAction)duplicateGPCatalogEntry:(id)sender;
- (IBAction)removeSelectedGPCatalogEntries:(id)sender;

- (IBAction)addToGPCatalogSet:(id)sender;
- (IBAction)addSelectedEntriesToSet:(id)sender;

- (IBAction)addToLooksLike:(id)sender;
- (IBAction)addSelectedEntriesToLooksLike:(id)sender;

- (IBAction)manageSets:(id)sender;
- (IBAction)manageLooksLike:(id)sender;
- (IBAction)manageTopics:(id)sender;

@property (strong, nonatomic) NSPredicate * lastViewedQuery;

- (IBAction)viewSubvarieties:(id)sender;
- (IBAction)closeSubvarieties:(id)sender;

- (IBAction)viewSetsForGPCatalogEntry:(id)sender;

- (IBAction)viewLooksLikeForGPCatalogEntry:(id)sender;

- (IBAction)addAlternateCatalog:(id)sender;

- (IBAction)addDefaultPicture:(id)sender;
- (IBAction)addAlternatePicture1:(id)sender;
- (IBAction)addAlternatePicture2:(id)sender;
- (IBAction)addAlternatePicture3:(id)sender;
- (IBAction)addAlternatePicture4:(id)sender;
- (IBAction)addAlternatePicture5:(id)sender;
- (IBAction)addAlternatePicture6:(id)sender;

- (IBAction)addIdentificationPicture:(id)sender;
- (IBAction)removeIdentificationPicture:(id)sender;

- (IBAction)addPlateUsage:(id)sender;
- (IBAction)removePlateUsage:(id)sender;
- (IBAction)addPlateNumberCombination:(id)sender;
- (IBAction)removePlateNumberCombination:(id)sender;

- (IBAction)addCachet:(id)sender;
- (IBAction)removeCachet:(id)sender;

- (IBAction)addPrecancel:(id)sender;
- (IBAction)removePrecancel:(id)sender;
- (IBAction)addPictureToPrecancel:(id)sender;

- (IBAction)addCancelation:(id)sender;
- (IBAction)removeCancelation:(id)sender;

@property (strong, nonatomic) Topic * selectedTopic;
- (IBAction)addTopic:(id)sender;
- (IBAction)removeTopic:(id)sender;

@end
