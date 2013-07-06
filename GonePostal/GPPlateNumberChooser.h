//
//  GPPlateNumberChooser.h
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalog.h"
#import "Stamp.h"

@interface GPPlateNumberChooser : NSViewController

// The GPCatalog entry associated with the stamp
@property (strong, nonatomic) GPCatalog * gpCatalog;

// The stamp being modified.
@property (strong, nonatomic) Stamp * stamp;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * plateUsageSortDescriptors;
@property (strong, nonatomic) NSArray * plateCombinationsSortDescriptors;

@property (strong, nonatomic) NSDrawer * drawer;

// Formats selected plate info into this control, which
// is owned by the parent.
@property (weak, nonatomic) NSTextField *plateInfoField;

@property (strong, nonatomic) NSString * selectedPlatePosition;

/**
 * Initialize the panel with a GPCatalog
 * pass in allocated pointers which the panel fills in
 * when done is pressed.
 */
- (id)initAsDrawer:(BOOL)isDrawer modifyingStamp:(Stamp *)stamp;

- (void)clearManualPlateEntry;
- (void)formatPlateInfo;

@end
