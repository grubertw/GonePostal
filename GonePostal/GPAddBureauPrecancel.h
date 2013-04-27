//
//  GPAddBureauPrecancel.h
//  GonePostal
//
//  Created by Travis Gruber on 4/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "BureauPrecancel.h"

@interface GPAddBureauPrecancel : NSWindowController

@property (strong, nonatomic) GPCatalog * gpCatalog;
@property (strong, nonatomic) BureauPrecancel * currPrecancel;

@property (strong, nonatomic) NSArray * precancelsSortDescriptors;

@property (strong, nonatomic) NSMutableArray * addedPrecancels;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog;

@end
