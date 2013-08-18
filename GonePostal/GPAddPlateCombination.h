//
//  GPAddPlateCombination.h
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "GPPlateCombinationsEditor.h"

@interface GPAddPlateCombination : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpPlateCombinationsSortDescriptors;
@property (strong, nonatomic) NSArray * platePositionsSortDescriptors;

@property (strong, nonatomic) GPCatalog * gpCatalog;
@property (strong, nonatomic) GPPlateCombinationsEditor * plateCombosEditor;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalogEntry editor:(GPPlateCombinationsEditor *)editor;

@end
