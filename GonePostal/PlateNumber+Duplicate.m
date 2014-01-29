//
//  PlateNumber+Duplicate.m
//  GonePostal
//
//  Created by Travis Gruber on 7/2/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "PlateNumber+Duplicate.h"

@implementation PlateNumber (Duplicate)

- (PlateNumber *)duplicate {
    PlateNumber *pnCopy = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
    
    pnCopy.gp_plate_combination_number = self.gp_plate_combination_number;
    pnCopy.combination_unknown = self.combination_unknown;
    pnCopy.imprint_1 = self.imprint_1;
    pnCopy.imprint_2 = self.imprint_2;
    pnCopy.marking = self.marking;
    pnCopy.notes = self.notes;
    pnCopy.max_percentage = self.max_percentage;
    pnCopy.number_of_stamps = self.number_of_stamps;
    pnCopy.plate1 = self.plate1;
    pnCopy.plate2 = self.plate2;
    pnCopy.plate3 = self.plate3;
    pnCopy.plate4 = self.plate4;
    pnCopy.plate5 = self.plate5;
    pnCopy.plate6 = self.plate6;
    pnCopy.plate7 = self.plate7;
    pnCopy.plate8 = self.plate8;
    pnCopy.unreported = self.unreported;
    pnCopy.very_rare = self.very_rare;
    
    [pnCopy addModifyingPlatePositions:self.modifyingPlatePositions];
    
    return pnCopy;
}

@end
