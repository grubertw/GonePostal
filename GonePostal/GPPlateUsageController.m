//
//  GPPlateUsageController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateUsageController.h"
#import "PlateUsage.h"
#import "GPDocument.h"

@interface GPPlateUsageController ()

@end

@implementation GPPlateUsageController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        NSSortDescriptor *platePositionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _platePositionsSortDescriptors = @[platePositionsSort];
    }
    
    return self;
}

- (IBAction)addPlatePositionToPlateUsage:(id)sender {
    PlateUsage * plateUsage = (PlateUsage *)self.representedObject;
    
    if (self.selectedPlatePosition == nil) return;
    [plateUsage addPlatePositionsObject:self.selectedPlatePosition];
}

- (IBAction)removePlatePositionFromPlateUsage:(id)sender {
    PlateUsage * plateUsage = (PlateUsage *)self.representedObject;
    
    NSArray * selectedPlatePositions = self.platePositionsInPlateUsageController.selectedObjects;
    [plateUsage removePlatePositions:[NSSet setWithArray:selectedPlatePositions]];
}

@end
