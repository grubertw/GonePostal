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
#import "NumberOfStampsInPlate.h"
#import "StampFormat.h"

@interface GPPlateNumberChooser ()
@property (nonatomic) BOOL isDrawer;

@property (strong, nonatomic) IBOutlet NSCollectionView * plateUsageCollection;
@property (weak, nonatomic) IBOutlet NSTableView *plateCombinationsTable;

@property (strong, nonatomic) IBOutlet NSArrayController *plateUsageController;
@property (strong, nonatomic) IBOutlet NSArrayController *plateCombinationsController;

@property (weak, nonatomic) IBOutlet NSTextField * plate1;
@property (weak, nonatomic) IBOutlet NSTextField * plate2;
@property (weak, nonatomic) IBOutlet NSTextField * plate3;
@property (weak, nonatomic) IBOutlet NSTextField * plate4;
@property (weak, nonatomic) IBOutlet NSTextField * plate5;
@property (weak, nonatomic) IBOutlet NSTextField * plate6;
@property (weak, nonatomic) IBOutlet NSTextField * plate7;
@property (weak, nonatomic) IBOutlet NSTextField * plate8;
@property (weak, nonatomic) IBOutlet NSTextField * imprint1;
@property (weak, nonatomic) IBOutlet NSTextField * imprint2;
@property (weak, nonatomic) IBOutlet NSTextField * marking;
@property (weak, nonatomic) IBOutlet NSTextField * position;

@end

@implementation GPPlateNumberChooser

- (id)initAsDrawer:(BOOL)isDrawer modifyingStamp:(Stamp *)stamp
{
    self = [super initWithNibName:@"GPPlateNumberChooser" bundle:nil];
    if (self) {
        _isDrawer = isDrawer;
        
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
    
    [self filterPlateNumbers];
}

- (void)filterPlateNumbers {
    NSMutableArray * filters = [NSMutableArray arrayWithCapacity:1];
    for (NumberOfStampsInPlate * n in self.gpCatalog.numberOfStampsInPlate) {
        if ([self.stamp.format isEqualTo:n.stampFormat]) {
            NSPredicate *filter = [NSPredicate predicateWithFormat:@"number_of_stamps == %@",
                                   n.numberOfStamps];
            [filters addObject:filter];
        }
    }
    NSCompoundPredicate * pred = [NSCompoundPredicate orPredicateWithSubpredicates:filters];
    
    [self.plateCombinationsController setFilterPredicate:pred];
    [self.plateCombinationsController rearrangeObjects];
    
    if (self.stamp.plateNumber != nil) {
        NSArray * sel = [NSArray arrayWithObject:self.stamp.plateNumber];
        [self.plateCombinationsController setSelectedObjects:sel];
    }
}

- (void)clearManualPlateEntry {
    [self.plate1 setStringValue:@""];
    [self.plate2 setStringValue:@""];
    [self.plate3 setStringValue:@""];
    [self.plate4 setStringValue:@""];
    [self.plate5 setStringValue:@""];
    [self.plate6 setStringValue:@""];
    [self.plate7 setStringValue:@""];
    [self.plate8 setStringValue:@""];
    [self.imprint1 setStringValue:@""];
    [self.imprint2 setStringValue:@""];
    [self.marking setStringValue:@""];
    [self.position setStringValue:@""];
}

- (IBAction)closeChooser:(id)sender {
    // Set the selected plate position from the plate usage chooser.
    if ([self.gpCatalog.plateUsage count] > 0) {
        GPPlateUsageChooser * item = (GPPlateUsageChooser *)[self.plateUsageCollection itemAtIndex:0];
        self.selectedPlatePosition = item.selectedPlatePosition.name;
    }
    
    NSArray * selection = self.plateCombinationsController.selectedObjects;
    
    if (selection && [selection count] > 0) {
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
        self.stamp.marking = selectedPlateCombo.marking;
        self.stamp.plate_position = self.selectedPlatePosition;
        self.stamp.plateNumber = selectedPlateCombo; // Ref so this selection can reappear if choosing again.
    }
    else {
        self.stamp.plate_1 = [self.plate1 stringValue];
        self.stamp.plate_2 = [self.plate2 stringValue];
        self.stamp.plate_3 = [self.plate3 stringValue];
        self.stamp.plate_4 = [self.plate4 stringValue];
        self.stamp.plate_5 = [self.plate5 stringValue];
        self.stamp.plate_6 = [self.plate6 stringValue];
        self.stamp.plate_7 = [self.plate7 stringValue];
        self.stamp.plate_8 = [self.plate8 stringValue];
        self.stamp.inprint_1 = [self.imprint1 stringValue];
        self.stamp.inprint_2 = [self.imprint2 stringValue];
        self.stamp.marking = [self.marking stringValue];
        self.stamp.plate_position = [self.position stringValue];
    }
    
    // Format the selected plate info into the control set by the parent.
    [self formatPlateInfo];
    
    if (self.isDrawer) {
        [self.drawer close];
    }
    else {
        [self.view removeFromSuperview];
    }
}

- (void)formatPlateInfo {
    NSString * plateInfo = @"Plate Number(s):\n";
 
    if (self.stamp.plate_1 && [self.stamp.plate_1 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_1];
    }
    if (self.stamp.plate_2 && [self.stamp.plate_2 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_2];
    }
    if (self.stamp.plate_3 && [self.stamp.plate_3 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_3];
    }
    if (self.stamp.plate_4 && [self.stamp.plate_4 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_4];
    }
    if (self.stamp.plate_5 && [self.stamp.plate_5 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_5];
    }
    if (self.stamp.plate_6 && [self.stamp.plate_6 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_6];
    }
    if (self.stamp.plate_7 && [self.stamp.plate_7 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_7];
    }
    if (self.stamp.plate_8 && [self.stamp.plate_8 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t%@\n", self.stamp.plate_8];
    }
    
    plateInfo = [plateInfo stringByAppendingString:@"Imprint(s):\n"];
    
    if (self.stamp.inprint_1 && [self.stamp.inprint_1 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t#%@\n", self.stamp.inprint_1];
    }
    if (self.stamp.inprint_2 && [self.stamp.inprint_2 length] > 0) {
        plateInfo = [plateInfo stringByAppendingFormat:@"\t#%@\n", self.stamp.inprint_2];
    }
    
    plateInfo = [plateInfo stringByAppendingFormat:@"With marking: %@\n", self.stamp.marking];
    
    plateInfo = [plateInfo stringByAppendingFormat:@"At position: %@\n", self.stamp.plate_position];
    
    [self.plateInfoField setStringValue:plateInfo];
}

@end
