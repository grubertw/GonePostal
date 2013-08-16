//
//  GPPlateCombinationsEditor.m
//  GonePostal
//
//  Created by Travis Gruber on 7/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateCombinationsEditor.h"
#import "GPAddPlateCombination.h"
#import "GPDocument.h"
#import "GPCatalog.h"
#import "PlateNumber+Duplicate.h"
#import "NumberOfStampsInPlate.h"
#import "PlateUsage.h"
#import "GPCustomSearch.h"

static const NSUInteger DUPLICATE_PLATE_COMBO   = 1;
static const NSUInteger EXPLODE_PLATE           = 2;
static const NSUInteger EXPLODE_NUMBER          = 3;

@interface GPPlateCombinationsEditor ()
@property (strong, nonatomic) IBOutlet NSArrayController *plateCombinationsController;
@property (strong, nonatomic) NSMutableArray *plateCombinations;

@property (strong, nonatomic) IBOutlet NSArrayController *disallowedPlatePositionsController;
@property (strong, nonatomic) IBOutlet NSArrayController *allowedPlatePositionsController;
@property (strong, nonatomic) NSMutableSet *allowedPlatePositions;

@property (strong, nonatomic) IBOutlet NSPanel * createPanel;

@property (nonatomic) NSUInteger promptAction;
@property (weak, nonatomic) IBOutlet NSTextField * startingGPID;
@end

@implementation GPPlateCombinationsEditor

- (id)initWithGPCatalog:(GPCatalog *)gpCatalogEntry {
    self = [super initWithWindowNibName:@"GPPlateCombinationsEditor"];
    if (self) {
        _gpCatalog = gpCatalogEntry;
        _managedObjectContext = gpCatalogEntry.managedObjectContext;
        
        // Create the sort descripors
        NSSortDescriptor *plateCombinationsSort = [[NSSortDescriptor alloc] initWithKey:@"gp_plate_combination_number" ascending:YES];
        _gpPlateCombinationsSortDescriptors = @[plateCombinationsSort];
        
        NSSortDescriptor *platePositionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _platePositionsSortDescriptors = @[platePositionsSort];
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
        
        _plateCombinations = [[NSMutableArray alloc] initWithCapacity:0];
        [_plateCombinations setArray:[_gpCatalog.plateNumbers allObjects]];
        
        _allowedPlatePositions = [[NSMutableSet alloc] initWithCapacity:0];
        _promptAction = 0;
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return [NSString stringWithFormat:@"Plate Numbers for GPID %@", self.gpCatalog.gp_catalog_number];
}

- (IBAction)executeCustomSearch:(id)sender {
    if (!self.currCustomSearch) return;
    
    NSFetchRequest * fetch = [NSFetchRequest fetchRequestWithEntityName:@"PlateNumber"];
    [fetch setPredicate:self.currCustomSearch.predicate];
    
    NSArray * results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
    [self.plateCombinations setArray:results];
    [self.plateCombinationsController rearrangeObjects];
}

- (IBAction)editCustomSearches:(id)sender {
    GPCustomSearch * customSearchController = [[GPCustomSearch alloc] initWithStoredSearchIdentifier:@(CUSTOM_PLATE_NUMBERS_SEARCH_ID)];
    [customSearchController setDefaultGPCatalog:self.gpCatalog];
    
    [self.document addWindowController:customSearchController];
    [customSearchController.window makeKeyAndOrderFront:sender];
}

- (IBAction)addPlateCombination:(id)sender {
    GPAddPlateCombination * controller = [[GPAddPlateCombination alloc] initWithGPCatalog:self.gpCatalog];
    [self.document addWindowController:controller];
    
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)removePlateCombination:(id)sender {
    [self.plateCombinationsController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)openDuplicatePrompt:(id)sender {
    PlateNumber * lastPlate = [[self.plateCombinationsController selectedObjects] lastObject];
    if (!lastPlate) return;
    
    NSString * staticID = [GPDocument parseStaticID:lastPlate.gp_plate_combination_number];
    NSInteger startingID = [GPDocument parseStartingID:lastPlate.gp_plate_combination_number];
    startingID += GPID_INCREMENT;
    [self.startingGPID setStringValue:[NSString stringWithFormat:@"%@%08ld", staticID, startingID]];
    
    self.promptAction = DUPLICATE_PLATE_COMBO;
    [NSApp beginSheet:self.createPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)openExplodePlatesPrompt:(id)sender {
    PlateNumber * lastPlate = [[self.plateCombinationsController arrangedObjects] lastObject];
    
    NSString * staticID = [GPDocument parseStaticID:lastPlate.gp_plate_combination_number];
    NSInteger startingID = [GPDocument parseStartingID:lastPlate.gp_plate_combination_number];
    startingID += GPID_INCREMENT;
    [self.startingGPID setStringValue:[NSString stringWithFormat:@"%@%08ld", staticID, startingID]];
    
    self.promptAction = EXPLODE_PLATE;
    [NSApp beginSheet:self.createPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)openExplodeNumbersPrompt:(id)sender {
    PlateNumber * lastPlate = [[self.plateCombinationsController arrangedObjects] lastObject];
    
    NSString * staticID = [GPDocument parseStaticID:lastPlate.gp_plate_combination_number];
    NSInteger startingID = [GPDocument parseStartingID:lastPlate.gp_plate_combination_number];
    startingID += GPID_INCREMENT;
    [self.startingGPID setStringValue:[NSString stringWithFormat:@"%@%08ld", staticID, startingID]];
    
    self.promptAction = EXPLODE_NUMBER;
    [NSApp beginSheet:self.createPanel modalForWindow:self.window modalDelegate:self didEndSelector:nil contextInfo:nil];
}

- (IBAction)closePrompt:(id)sender {
    NSString * staticID = [GPDocument parseStaticID:[self.startingGPID stringValue]];
    if (!staticID) {
        [NSApp endSheet:self.createPanel];
        [self.createPanel orderOut:sender];
        NSAlert * alertSheet = [NSAlert alertWithMessageText:nil defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Invalid format entered for GPID.  Number must be formatted with dashes."];
        
        [alertSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        self.promptAction = 0;
        return;
    }
    
    NSInteger startingID = [GPDocument parseStartingID:[self.startingGPID stringValue]];
    
    if (self.promptAction == DUPLICATE_PLATE_COMBO)
        [self duplatePlateCombination:staticID withStartingID:startingID];
    else if (self.promptAction == EXPLODE_PLATE)
        [self explodePlates:staticID withStartingID:startingID];
    else if (self.promptAction == EXPLODE_NUMBER)
        [self explodeNumbers:staticID withStartingID:startingID];
    
    self.promptAction = 0;
    [NSApp endSheet:self.createPanel];
    [self.createPanel orderOut:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)cancelPrompt:(id)sender {
    self.promptAction = 0;
    [NSApp endSheet:self.createPanel];
    [self.createPanel orderOut:sender];
}

- (void)duplatePlateCombination:(NSString *)initialGPID withStartingID:(NSInteger)startingID {
    for (PlateNumber * plateCombo in self.plateCombinationsController.selectedObjects) {
        PlateNumber * pnCopy = [plateCombo duplicate];
        
        // Assign and increment the GPID.
        pnCopy.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", initialGPID, startingID];
        startingID += GPID_INCREMENT;
        
        [self.gpCatalog addPlateNumbersObject:pnCopy];
    }
}

// When number of stamps is 0, this acts as a key for expolding out combinations.
// When plate1 is set and plate2 is empty, an array is created with plate1's.
// When plate2 is set and plate1 is empty, an array is created with plate2's.
// a 2d for loop then iterates through these arrays, creating all the combinations.
- (void)explodePlates:(NSString *)initialGPID withStartingID:(NSInteger)startingID {
    NSMutableArray * plate1s = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray * plate2s = [NSMutableArray arrayWithCapacity:0];
    
    for (PlateNumber *pn in self.gpCatalog.plateNumbers) {
        if ([pn.number_of_stamps isEqualToNumber:@(0)]) {
            if (pn.plate1 && !pn.plate2) {
                [plate1s addObject:pn];
            }
            else if (!pn.plate1 && pn.plate2) {
                [plate2s addObject:pn];
            }
        }
    }
    
    [plate1s sortUsingDescriptors:self.gpPlateCombinationsSortDescriptors];
    [plate2s sortUsingDescriptors:self.gpPlateCombinationsSortDescriptors];
    
    // Blow out all plate1 + plate2 combinations.
    for (PlateNumber *plate1 in plate1s) {
        for (PlateNumber *plate2 in plate2s) {
            PlateNumber *pnCopy = [plate1 duplicate];
            pnCopy.plate2 = plate2.plate2;
            
            // Assign and increment the GPID.
            pnCopy.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", initialGPID, startingID];
            startingID += GPID_INCREMENT;
            
            [self.gpCatalog addPlateNumbersObject:pnCopy];
        }
    }
}

// As there are plate combinations that exist that have both 2 stamps, 3 stamps
// and 4 stamps (for example), all these combinations need to be created.  Use
// number_of_stamps=0 as the key for blowing out the combinations.
- (void)explodeNumbers:(NSString *)initialGPID withStartingID:(NSInteger)startingID {
    NSMutableArray * keyPlates = [NSMutableArray arrayWithArray:[self.gpCatalog.plateNumbers allObjects]];
    [keyPlates sortUsingDescriptors:self.gpPlateCombinationsSortDescriptors];
    [keyPlates filterUsingPredicate:[NSPredicate predicateWithFormat:@"number_of_stamps==0"]];
    
    NSMutableArray * numStampsCombos = [NSMutableArray arrayWithArray:[self.gpCatalog.numberOfStampsInPlate allObjects]];
    NSSortDescriptor * numStampsSort = [[NSSortDescriptor alloc] initWithKey:@"numberOfStamps" ascending:YES];
    [numStampsCombos sortUsingDescriptors:@[numStampsSort]];
    
    for (PlateNumber *pn in keyPlates) {
        for (NumberOfStampsInPlate *numStampsCombo in numStampsCombos) {
            PlateNumber *pnCopy = [pn duplicate];
            pnCopy.number_of_stamps = numStampsCombo.numberOfStamps;
            
            // Assign and increment the GPID.
            pnCopy.gp_plate_combination_number = [NSString stringWithFormat:@"%@%08ld", initialGPID, startingID];
            startingID += GPID_INCREMENT;

            [self.gpCatalog addPlateNumbersObject:pnCopy];
        }
    }
    
    // Key plates are no longer needed after this operation.
    [self.gpCatalog removePlateNumbers:[NSSet setWithArray:keyPlates]];
}

- (IBAction)addPicture:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.plateCombinationsController.selectedObjects;
    if (entries.count > 0) {
        PlateNumber * entry = [entries objectAtIndex:0];
        
        NSString * fileName = [self.document addFileToWrapperUsingGPID:entry.gp_plate_combination_number forAttribute:@"GPCatalog.default_picture" fileType:GPImportFileTypePicture];
        if (fileName == nil) return;
        
        entry.picture = fileName;
    }
}

- (IBAction)removePicture:(id)sender {
    // Store the filename into the model.
    NSArray * entries = self.plateCombinationsController.selectedObjects;
    if (entries.count > 0) {
        PlateNumber * entry = [entries objectAtIndex:0];
        entry.picture = @"empty";
    }
}

- (IBAction)disallowPlatePosition:(id)sender {
    NSArray * ppsToDisallow = [self.allowedPlatePositionsController selectedObjects];
    
    NSArray * entries = self.plateCombinationsController.selectedObjects;
    for (PlateNumber * entry in entries) {
        [entry addDisallowedPlatePositions:[NSSet setWithArray:ppsToDisallow]];
        
        [self.allowedPlatePositions minusSet:entry.disallowedPlatePositions];
        [self.allowedPlatePositionsController setContent:self.allowedPlatePositions];
    }
}

- (IBAction)allowPlatePosition:(id)sender {
    NSArray * ppsToAllow = [self.disallowedPlatePositionsController selectedObjects];
    NSSet * setOfPlatePositionsToAllow = [NSSet setWithArray:ppsToAllow];
    
    [self.allowedPlatePositions unionSet:setOfPlatePositionsToAllow];
    [self.allowedPlatePositionsController setContent:self.allowedPlatePositions];
    
    NSArray * entries = self.plateCombinationsController.selectedObjects;
    for (PlateNumber * entry in entries) {
        [entry removeDisallowedPlatePositions:setOfPlatePositionsToAllow];
    }
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    NSArray * selection = [self.plateCombinationsController selectedObjects];
    
    if ([selection count] > 0) {
        // Populate the allowed plate positions.
        NSSet * plateUsage = self.gpCatalog.plateUsage;

        NSUInteger i=0;
        for (PlateUsage * pu in plateUsage) {
            if (i == 0) {
                [self.allowedPlatePositions setSet:pu.platePositions];
            }
            else {
                [self.allowedPlatePositions intersectSet:pu.platePositions];
            }
            
            i++;
        }
        
        PlateNumber * plateCombo = selection[0];
        [self.allowedPlatePositions minusSet:plateCombo.disallowedPlatePositions];
        
        [self.allowedPlatePositionsController setContent:self.allowedPlatePositions];
    }
}

@end
