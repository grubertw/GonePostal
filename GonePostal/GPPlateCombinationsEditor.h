//
//  GPPlateCombinationsEditor.h
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#import "GPCatalog.h"

@interface GPPlateCombinationsEditor : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpPlateCombinationsSortDescriptors;
@property (strong, nonatomic) NSArray * platePositionsSortDescriptors;

@property (strong, nonatomic) GPCatalog * gpCatalog;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalogEntry;

@end
