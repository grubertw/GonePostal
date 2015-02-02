//
//  GPCatalogDefaults.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "AlternateCatalogGroup.h"
#import "StampFormat.h"

@interface GPCatalogDefaults : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * countriesSortDescriptors;
@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogSectionsSortDescriptors;
@property (strong, nonatomic) NSArray * gpGroupsSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogDateSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogPeopleSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogPlateSizeSortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogQuantitySortDescriptors;
@property (strong, nonatomic) NSArray * gpCatalogAlbumSizeSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * gpCatalogDefaultsController;

@property (strong, nonatomic) AlternateCatalogGroup * selectedAltCatalogSection;

// Used when adding allowed stamp formats to a GPCatalog entrey.
@property (strong, nonatomic) StampFormat * allowedStampFormatToAdd;

- (IBAction)save:(id)sender;

@end
