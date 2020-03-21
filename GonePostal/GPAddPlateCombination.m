//
//  GPAddPlateCombination.m
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAddPlateCombination.h"
#import "PlateNumber+Duplicate.h"
#import "PlatePosition.h"
#import "PlateUsage.h"
#import "GonePostal-Swift.h"

@interface GPAddPlateCombination ()
@property (strong, nonatomic) IBOutlet NSObjectController *plateCombinationController;

@property (strong, nonatomic) IBOutlet NSArrayController * addedGPIDsController;
@property (strong, nonatomic) NSMutableArray * addedGPIDs;

@property (weak, nonatomic) IBOutlet NSTextField * quantityInput;
@property (weak, nonatomic) IBOutlet NSTableView * addedGPIDsTable;

@property bool savePressed;
@end

@implementation GPAddPlateCombination

- (id)initWithGPCatalog:(GPCatalog *)gpCatalogEntry editor:(GPPlateCombinationsEditor *)editor {
    self = [super initWithWindowNibName:@"GPAddPlateCombination"];
    if (self) {
        _gpCatalog = gpCatalogEntry;
        _plateCombosEditor = editor;
        _managedObjectContext = gpCatalogEntry.managedObjectContext;
        
        // Create the sort descripors
        NSSortDescriptor *plateCombinationsSort = [[NSSortDescriptor alloc] initWithKey:@"gp_plate_combination_number" ascending:NO];
        _gpPlateCombinationsSortDescriptors = @[plateCombinationsSort];
        
        NSSortDescriptor *platePositionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _platePositionsSortDescriptors = @[platePositionsSort];
        
        _addedGPIDs = [[NSMutableArray alloc] initWithCapacity:0];
        _savePressed = false;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Save any uncommited changes before beginning.
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.window performClose:self];
        return;
    }
    
    PlateNumber * plateCombo = [NSEntityDescription insertNewObjectForEntityForName:@"PlateNumber" inManagedObjectContext:self.managedObjectContext];
    plateCombo.gp_plate_combination_number = self.gpCatalog.gp_catalog_number;
    [self.plateCombinationController setContent:plateCombo];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Add a Plate Number Combination";
}

- (IBAction)addPlateCombinations:(id)sender {
    PlateNumber * plateCombo = [self.plateCombinationController content];
    
    // Get the incrmenting and non-incrmenting part of the GPID.
    NSString * staticID = [GPDocument parseStaticID:plateCombo.gp_plate_combination_number];
    NSInteger startingID = [GPDocument parseStartingID:plateCombo.gp_plate_combination_number];
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the PlateNumber from the model controller.
        for (NSInteger i=0; i<count; i++) {
            PlateNumber * dup = [plateCombo duplicate];
            
            // Increment and assign the GPID.
            startingID += GPDocument.GPID_INCREMENT;
            dup.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
            
            [self.gpCatalog addPlateNumbersObject:dup];
            [self.addedGPIDs addObject:dup];
            [self.addedGPIDsController setContent:self.addedGPIDs];
        }
    }
    
    [self.gpCatalog addPlateNumbersObject:plateCombo];
    
    // Track the added GPIDs for display purposes.
    [self. addedGPIDs addObject:plateCombo];
    [self.addedGPIDsController setContent:self.addedGPIDs];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext rollback];
    }
    
    // Prepare for the next entry.
    PlateNumber * nextPlateCombo = [plateCombo duplicate];
    
    // Increment and assign the GPID.
    startingID += GPDocument.GPID_INCREMENT;
    nextPlateCombo.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
    
    [self.plateCombinationController setContent:nextPlateCombo];
}

- (IBAction)save:(id)sender {
    self.savePressed = true;
    
    PlateNumber * plateCombo = [self.plateCombinationController content];
    
    // Get the incrmenting and non-incrmenting part of the GPID.
    NSString * staticID = [GPDocument parseStaticID:plateCombo.gp_plate_combination_number];
    NSInteger startingID = [GPDocument parseStartingID:plateCombo.gp_plate_combination_number];
    
    NSInteger count = [self.quantityInput integerValue];
    if (count > 1) {
        count--;
        
        // Duplicate the PlateNumber from the model controller.
        for (NSInteger i=0; i<count; i++) {
            PlateNumber * dup = [plateCombo duplicate];
            
            // Increment and assign the GPID.
            startingID += GPDocument.GPID_INCREMENT;
            dup.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", staticID, startingID];
            
            [self.gpCatalog addPlateNumbersObject:dup];
            [self.addedGPIDs addObject:dup];
        }
    }
    
    [self.gpCatalog addPlateNumbersObject:plateCombo];
    [self.addedGPIDs addObject:plateCombo];
    [self.plateCombosEditor.plateCombinationsController addObjects:self.addedGPIDs];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext rollback];
    }
    
    [self.window performClose:sender];
}

- (IBAction)cancel:(id)sender {
    [self.window performClose:sender];
}

- (IBAction)addPicture:(id)sender {
    // Store the filename into the model.
    PlateNumber * plateCombo = [self.plateCombinationController content];
    if (plateCombo) {
        NSString * fileName = [self.document addImageToWrapperUsingGPID:plateCombo.gp_plate_combination_number forAttribute:@"GPCatalog.default_picture"];
        if (fileName == nil) return;
        
        plateCombo.picture = fileName;
    }
}

- (IBAction)removePicture:(id)sender {
    // Store the filename into the model.
    PlateNumber * plateCombo = [self.plateCombinationController content];
    if (plateCombo) {
        plateCombo.picture = @"empty";
    }
}

- (void)windowWillClose:(NSNotification *)notification {
    if (!self.savePressed) {
        // Rollback all changed to the managed object context
        // that have not been explicitly saved.
        [self.managedObjectContext rollback];
    }
}

@end
