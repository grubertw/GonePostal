//
//  GPStampViewer.h
//  GonePostal
//
//  Created by Travis Gruber on 3/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StoredSearch.h"
#import "GPCollection.h"
#import "Stamp.h"

@interface MyStamps : NSCollectionView
@end

@interface GPStampViewer : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) GPCollection * myCollection;
@property (strong, nonatomic) Stamp * selectedComposite;

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * stampSortDescriptors;

@property (strong, nonatomic) StoredSearch * assistedSearch;
@property (strong, nonatomic) NSPredicate * countriesPredicate;
@property (strong, nonatomic) NSPredicate * sectionsPredicate;
@property (strong, nonatomic) NSPredicate * formatsPredicate;
@property (strong, nonatomic) NSPredicate * locationsPredicate;

- (id)initWithCollection:(GPCollection *)myCollection assistedSearch:(StoredSearch *)assistedSearch countrySearch:(NSPredicate *)countriesPredicate sectionSearch:(NSPredicate *)sectionsPredicate formatSearch:(NSPredicate *)formatsPredicate locationSearch:(NSPredicate *)locationsPredicate;

// Force the NSArrayController to re-apply the filter predicate
- (void)refilterStamps;

@end
