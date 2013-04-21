//
//  GPPlateNumberChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/12/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateNumberChooser.h"
#import "GPPlateUsageChooser.h"
#import "PlateNumber.h"
#import "PlateUsage.h"

@interface GPPlateNumberChooser ()
@property (nonatomic) BOOL isSheet;

@property (strong, nonatomic) IBOutlet NSCollectionView * plateUsageCollection;
@property (weak, nonatomic) IBOutlet NSTableView *plateCombinationsTable;

@property (strong, nonatomic) IBOutlet NSArrayController *plateUsageController;
@property (strong, nonatomic) IBOutlet NSArrayController *plateCombinationsController;
@end

@implementation GPPlateNumberChooser

- (id)initAsSheet:(BOOL)isSheet modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPPlateNumberChooser" bundle:nil];
    if (self) {
        _isSheet = isSheet;
        
        NSSortDescriptor *plateUsageSort = [[NSSortDescriptor alloc] initWithKey:@"plate_number" ascending:YES];
        _plateUsageSortDescriptors = @[plateUsageSort];
        
        NSSortDescriptor *plateNumber1Sort = [[NSSortDescriptor alloc] initWithKey:@"plate1" ascending:YES];
        NSSortDescriptor *plateNumber2Sort = [[NSSortDescriptor alloc] initWithKey:@"plate2" ascending:YES];
        _plateCombinationsSortDescriptors = @[plateNumber1Sort, plateNumber2Sort];
        
        _managedObjectContext = stamp.managedObjectContext;
        _stamp = stamp;
    }
    
    return self;
}

- (void)setGpCatalog:(GPCatalog *)gpCatalog {
    _gpCatalog = gpCatalog;
    
    NSUInteger numPlates = [self.gpCatalog.plateUsage count];
    
    // Iterate through the table columns in the plate combos table.
    // Hide columnes for plate usages that do not exist.
    NSArray * columns = [self.plateCombinationsTable tableColumns];
    for (NSUInteger i=0; i < 8; i++) {
        NSTableColumn * column = columns[i];
        if (i < numPlates) {
            [column setHidden:NO];
        }
        else {
            [column setHidden:YES];
        }
    }
}

- (IBAction)closeChooser:(id)sender {
    // Set the selected plate position from the plate usage chooser.
    if ([self.gpCatalog.plateUsage count] > 0) {
        GPPlateUsageChooser * item = (GPPlateUsageChooser *)[self.plateUsageCollection itemAtIndex:0];
        self.selectedPlatePosition = item.selectedPlatePosition.name;
    }
    
    if ([self.plateCombinationsController.selectedObjects count] > 0) {
        PlateNumber * selectedPlateCombo = self.plateCombinationsController.selectedObjects[0];
        self.stamp.plate_1 = selectedPlateCombo.plate1;
        self.stamp.plate_2 = selectedPlateCombo.plate2;
        self.stamp.plate_3 = selectedPlateCombo.plate3;
        self.stamp.plate_4 = selectedPlateCombo.plate4;
        self.stamp.plate_5 = selectedPlateCombo.plate5;
        self.stamp.plate_6 = selectedPlateCombo.plate6;
        self.stamp.plate_7 = selectedPlateCombo.plate7;
        self.stamp.plate_8 = selectedPlateCombo.plate8;
        self.stamp.inprint_1 = selectedPlateCombo.imprint_1;
        self.stamp.inprint_2 = selectedPlateCombo.imprint_2;
        
        self.stamp.plate_position = self.selectedPlatePosition;
    }
    
    // Format the selected plate info into the control set by the parent.
    [self formatPlateInfo];
    
    if (self.isSheet) {
        // End the sheet.
        NSApplication * app = [NSApplication sharedApplication];
        [app endSheet:self.view.window];
        [self.view.window close];
    }
    else {
        [self.drawer close];
    }
}

- (void)formatPlateInfo {
    NSString * plateInfo = @"Printed using:\nplate #";
 
    BOOL goodToGo = NO;
    if (self.stamp.plate_1) goodToGo = YES;
    
    NSArray * sortedPlateUsage = [self.stamp.gpCatalog.plateUsage sortedArrayUsingDescriptors:self.plateUsageSortDescriptors];
    
    for (PlateUsage * pu in sortedPlateUsage) {
        if ([pu.plate_number isEqualToNumber:@(1)]) {
            if (!self.stamp.plate_1) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_1];
            if (!self.stamp.plate_2) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(2)]) {
            if (!self.stamp.plate_2) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_2];
            if (!self.stamp.plate_3) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(3)]) {
            if (!self.stamp.plate_3) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_3];
            if (!self.stamp.plate_4) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(4)]) {
            if (!self.stamp.plate_4) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_4];
            if (!self.stamp.plate_5) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(5)]) {
            if (!self.stamp.plate_5) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_5];
            if (!self.stamp.plate_6) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(6)]) {
            if (!self.stamp.plate_6) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_6];
            if (!self.stamp.plate_7) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(7)]) {
            if (!self.stamp.plate_7) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_7];
            if (!self.stamp.plate_8) goodToGo = NO;
        }
        else if ([pu.plate_number isEqualToNumber:@(8)]) {
            if (!self.stamp.plate_8) break;
            plateInfo = [plateInfo stringByAppendingFormat:@"%@\n", self.stamp.plate_8];
            goodToGo = NO;
        }
        
        if (goodToGo) {
            plateInfo = [plateInfo stringByAppendingString:@"  and #"];
        }
    }
    
    if (self.stamp.inprint_1) {
        plateInfo = [plateInfo stringByAppendingFormat:@"with Imprint #%@", self.stamp.inprint_1];
    }
    if (self.stamp.inprint_2) {
        plateInfo = [plateInfo stringByAppendingFormat:@" and Imprint #%@", self.stamp.inprint_2];
    }
    
    plateInfo = [plateInfo stringByAppendingFormat:@"At position %@", self.stamp.plate_position];
    
    [self.plateInfoField setStringValue:plateInfo];
}

@end
