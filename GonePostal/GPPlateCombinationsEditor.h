//
//  GPPlateCombinationsEditor.h
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "StoredSearch.h"

@interface GPPlateCombinationsEditor : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) IBOutlet NSArrayController *plateCombinationsController;

@property (strong, nonatomic) NSArray * gpPlateCombinationsSortDescriptors;
@property (strong, nonatomic) NSArray * platePositionsSortDescriptors;
@property (strong, nonatomic) NSArray * customSearchSortDescriptors;

@property (strong, nonatomic) GPCatalog * gpCatalog;

@property (strong, nonatomic) StoredSearch * currCustomSearch;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalogEntry;

@end
