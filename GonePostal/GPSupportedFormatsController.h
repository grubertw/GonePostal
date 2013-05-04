//
//  GPSupportedFormatsController.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Format.h"
#import "StampFormat.h"

@interface GPSupportedFormatsController : NSWindowController <NSTableViewDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSArray * stampFormatSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

@property (strong, nonatomic) Format * selectedFormatType;
@property (strong, nonatomic) StampFormat * stampFormatToAdd;

- (IBAction)addFormat:(id)sender;
- (IBAction)deleteFormat:(id)sender;

@end
