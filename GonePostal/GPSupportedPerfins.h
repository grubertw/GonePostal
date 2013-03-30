//
//  GPSupportedPerfins.h
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "PerfinCatalogName.h"
#import "Perfin.h"

@interface GPSupportedPerfins : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * perfinSortDescriptors;
@property (strong, nonatomic) NSArray * perfinCatalogSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;

@property (strong, nonatomic) Perfin * selectedPerfin;
@end
