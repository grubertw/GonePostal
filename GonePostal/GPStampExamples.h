//
//  GPStampExamples.h
//  GonePostal
//
//  Created by Travis Gruber on 4/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"

@interface GPStampExamples : NSWindowController <NSTabViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) GPCatalog * gpCatalog;

@property (strong, nonatomic) NSArray * stampSortDescriptors;

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog;

@end
