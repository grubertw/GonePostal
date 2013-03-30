//
//  GPCachetChooser.h
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "Stamp.h"

@interface GPCachetChooser : NSViewController <NSTableViewDelegate>

@property (strong, nonatomic) GPCatalog * selectedGPCatalog;
@property (strong, nonatomic) Stamp * stamp;

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (strong, nonatomic) NSPanel * panel;

- (id)initAsSheet:(BOOL)isSheet modifyingStamp:(Stamp *)stamp;
@end
