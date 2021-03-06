//
//  GPNewStampPage.h
//  GonePostal
//
//  Created by Travis Gruber on 3/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "GPCollection.h"
#import "Stamp.h"

@interface GPNewStampPage : NSViewController <NSPageControllerDelegate>

@property (strong, nonatomic) GPCatalog * selectedGPCatalog;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * formatSortDescriptors;
@property (strong, nonatomic) NSArray * centeringSortDescriptors;
@property (strong, nonatomic) NSArray * soundnessSortDescriptors;
@property (strong, nonatomic) NSArray * gradeSortDescriptors;
@property (strong, nonatomic) NSArray * cancelQualitySortDescriptors;
@property (strong, nonatomic) NSArray * gumConditionSortDescriptors;
@property (strong, nonatomic) NSArray * hingedSortDescriptors;
@property (strong, nonatomic) NSArray * dealerSortDescriptors;
@property (strong, nonatomic) NSArray * lotSortDescriptors;
@property (strong, nonatomic) NSArray * locationSortDescriptors;
@property (strong, nonatomic) NSArray * mountSortDescriptors;

@property (weak, nonatomic) IBOutlet NSTextField * compositeQuantityInput;

- (id)initWithCollection:(id)stampCollection;

- (Stamp *)getCurrentStamp;

// Adds the stamp currently loaded into the page into the collection.
- (void)addCurrentStamp;
- (void)updateDynamicStampBoxes;
- (void)cleanup;

@end
