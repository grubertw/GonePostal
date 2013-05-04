//
//  GPSupportedStampFormats.h
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "StampFormat.h"
#import "Format.h"

@interface GPSupportedStampFormats : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSArray * formatTypeSortDescriptors;

@property (strong, nonatomic) StampFormat * selectedStampFormat;
@property (strong, nonatomic) Format * formatTypeToAdd;

@end
