//
//  GPLooksLikePopoverController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"

@interface GPLooksLikePopoverController : NSViewController

@property (strong, nonatomic) NSArray * looksLikeSortDescriptors;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) GPCatalog * selectedCatalogEntry;

- (IBAction)removeSelectedFromLooksLike:(id)sender;

@end
