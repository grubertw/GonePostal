//
//  GPCusomSearch.h
//  GonePostal
//
//  Created by Travis Gruber on 5/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StoredSearch.h"
#import "GPCatalog.h"

@interface GPCustomSearch : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * customSearchSortDescriptors;

@property (strong, nonatomic) GPCatalog * defaultGPCatalog; // Used to create PlateNumber custom searches.

- (id)initWithStoredSearchIdentifier:(NSNumber *)identifier;

@end
