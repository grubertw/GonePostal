//
//  GPImportController.m
//  GonePostal
//
//  Created by Travis Gruber on 4/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPImportController.h"
#import "GPDocument.h"
#import "GPCatalog.h"
#import "Country.h"
#import "Format.h"
#import "GPCatalogGroup.h"

// Used by parser to seporate columns in the CSV file.
static NSString * CSV_DELIMETER = @";";
// Used by the parser to mark an empty column.
static NSString * NOT_AVAILABLE = @"N/A";
// Name of the GPID field.
static NSString * GPID_FIELD = @"gp_catalog_number";
// Character pattern denoting a subvariety.
static NSString * SUBVARIETY_GPID = @"SUB";
// Character pattern denoting an expert subvariety.
static NSString * EXPERT_SUBVARIETY_GPID = @"EXP";

@interface GPImportController ()
@property (weak, nonatomic) IBOutlet NSPathControl * importPathChooser;
@property (weak, nonatomic) IBOutlet NSButton * createRelatedObjectsCheck;
@property (weak, nonatomic) IBOutlet NSButton * preventDuplicateGPIDsCheck;
@property (weak, nonatomic) IBOutlet NSButton * abortOnColumnNumberMisMatchCheck;

@property (weak, nonatomic) IBOutlet NSProgressIndicator * progressIndicator;
@property (weak, nonatomic) IBOutlet NSTextField * finishedLabel;

@property (strong, nonatomic) NSArray * sortDescriptors;

@property (strong, nonatomic) IBOutlet NSArrayController * availableGPCatalogAttributes;
@property (strong, nonatomic) IBOutlet NSArrayController * gpCatalogImportColumns;

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSEntityDescription * gpCatalogEntity;

@property (strong, nonatomic) NSMutableDictionary * countries;
@property (strong, nonatomic) NSMutableDictionary * formatTypes;
@property (strong, nonatomic) NSMutableDictionary * catalogGroups;

@property (nonatomic) NSUInteger addCount;

@end

@implementation GPImportController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        _addCount = 0;
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sortDescriptors = @[sort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        
        // Create a managed object context seporate from the persistant document's instance.
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:[doc.managedObjectContext persistentStoreCoordinator]];
        [_managedObjectContext setUndoManager:nil];
        
        _gpCatalogEntity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:_managedObjectContext];
        
        NSFetchRequest * fetch = [[NSFetchRequest alloc] init];
        
        // Fetch existing Country models.
        [fetch setEntity:[NSEntityDescription entityForName:@"Country" inManagedObjectContext:_managedObjectContext]];
        NSArray * results = [_managedObjectContext executeFetchRequest:fetch error:nil];
        _countries = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (Country * mObj in results) {
            [_countries setValue:mObj forKey:mObj.country_name];
        }
        
        // Fetch exsisting format type models.
        [fetch setEntity:[NSEntityDescription entityForName:@"Format" inManagedObjectContext:_managedObjectContext]];
        results = [_managedObjectContext executeFetchRequest:fetch error:nil];
        _formatTypes = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (Format * mObj in results) {
            [_formatTypes setValue:mObj forKey:mObj.formatName];
        }
        
        // Fetch existing catalog group models
        [fetch setEntity:[NSEntityDescription entityForName:@"GPCatalogGroup" inManagedObjectContext:_managedObjectContext]];
        results = [_managedObjectContext executeFetchRequest:fetch error:nil];
        _catalogGroups = [[NSMutableDictionary alloc] initWithCapacity:0];
        for (GPCatalogGroup * mObj in results) {
            [_catalogGroups setValue:mObj forKey:mObj.group_name];
        }
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    //
    // Insert the default colum ordering for importing GPCatalog data.
    //
    NSDictionary * gpCatalogProperties = [_gpCatalogEntity propertiesByName];
    
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"gp_catalog_number"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"series"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"gp_description"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"variety_description"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"denomination"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"formatType"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"color"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"watermark"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"perforation"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"paper_type"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"print"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"press"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"gum"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"tag"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"plate_variation_type"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"design_measurement"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"plate_size"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"pane_size"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"number_of_panes"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"date_issued"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"date_documented_first_use"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"printer"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"issue_location"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"quantity_printed"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"designers"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"engravers"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"country"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"catalogGroup"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"quantity_sold"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"color_variety"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"plate_variation"]];
    [self.gpCatalogImportColumns addObject:[gpCatalogProperties objectForKey:@"plated"]];
    NSArray * defaultGPCatalogProps = [self.gpCatalogImportColumns arrangedObjects];
    
    
    [self.availableGPCatalogAttributes addObjects:self.gpCatalogEntity.properties];
    [self.availableGPCatalogAttributes removeObjects:defaultGPCatalogProps];
    
    
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"default_picture"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_1"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_2"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_3"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_4"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_5"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternate_picture_6"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"is_custom"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"is_default"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"has_subvarieties"]];
    
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"alternateCatalogs"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"bureauPrecancels"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"cachets"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"cancelations"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"catalogSets"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"defaultCatalogName"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"fdcIssueLocation"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"looksLike"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"majorVariety"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"plateNumberInfos"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"plateNumbers"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"plateUsage"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"stamps"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"subvarieties"]];
    [self.availableGPCatalogAttributes removeObject:[gpCatalogProperties objectForKey:@"topics"]];
    
    [self.finishedLabel setHidden:YES];
}

- (IBAction)chooseFileToImport:(id)sender {
    NSOpenPanel * fileChooser = [NSOpenPanel openPanel];
    [fileChooser setCanChooseFiles:YES];
    [fileChooser setCanChooseDirectories:NO];
    [fileChooser setAllowsMultipleSelection:NO];
    
    NSInteger rc = [fileChooser runModal];
    if (rc != NSFileHandlingPanelOKButton) return;
    
    NSURL * fileURL = [[fileChooser URLs] objectAtIndex:0];
    [self.importPathChooser setURL:fileURL];
}

- (IBAction)includeGPAttribute:(id)sender {
    NSArray * selectedAttributes = [self.availableGPCatalogAttributes selectedObjects];
    [self.gpCatalogImportColumns addObjects:selectedAttributes];
    
    [self.availableGPCatalogAttributes removeObjects:selectedAttributes];
}

- (IBAction)excludeGPAttribute:(id)sender {
    NSArray * selectedAttributes = [self.gpCatalogImportColumns selectedObjects];
    [self.gpCatalogImportColumns removeObjects:selectedAttributes];
    
    [self.availableGPCatalogAttributes addObjects:selectedAttributes];
}

// Return yes if
BOOL (^stringInArrayCompare)(id, NSUInteger, BOOL *) = ^(id obj, NSUInteger idx, BOOL * stop){
    
    return NO;
};

- (BOOL)doImportGPCatalog {
    NSError * error;
    NSUInteger skipCount = 0;
    self.addCount = 0;
    
    // Read the chosen URL into a single string.
    NSString * csvData = [NSString stringWithContentsOfURL:[self.importPathChooser URL] encoding:NSMacOSRomanStringEncoding error:&error];
    if (csvData == nil) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        return NO;
    }
    
    // Wrap into a scanner and parse into lines.
    NSScanner * lineScanner = [[NSScanner alloc] initWithString:csvData];
    NSCharacterSet * nlCharSet = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet * csvDelimeter = [NSCharacterSet characterSetWithCharactersInString:CSV_DELIMETER];
    NSCharacterSet * hyphenCharSet = [NSCharacterSet characterSetWithCharactersInString:@"-"];
    [lineScanner setCharactersToBeSkipped:nlCharSet];
    
    NSDateFormatter * dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    
    // Skip the first line (the title line)
    NSString * line;
    [lineScanner scanUpToCharactersFromSet:nlCharSet intoString:&line];
    //NSLog(@"%@", line);
    
    GPCatalog * workingMajorVariety;
    NSString * workingSectionID;
    
    while (![lineScanner isAtEnd]) {
        [lineScanner scanUpToCharactersFromSet:nlCharSet intoString:&line];
        //NSLog(@"%@", line);
        
        // Wrap the line into another scanner, then seporate by comma.
        NSScanner * commaScanner = [[NSScanner alloc] initWithString:line];
        [commaScanner setCharactersToBeSkipped:nil];
        
        NSMutableArray * csvColumns = [[NSMutableArray alloc] initWithCapacity:0];
        
        // Scan the line into an array of strings.
        while (![commaScanner isAtEnd]) {
            NSString * column;
            [commaScanner scanUpToCharactersFromSet:csvDelimeter intoString:&column];
            [commaScanner setScanLocation:commaScanner.scanLocation+1];
            
            if (!column) column = NOT_AVAILABLE;
            [csvColumns addObject:column];
            //NSLog(@"  %@", column);
        }
        
        // Scan the last column
        NSString * column;
        [commaScanner scanUpToCharactersFromSet:nlCharSet intoString:&column];
        if (!column) column = NOT_AVAILABLE;
        [csvColumns addObject:column];
        
        
        // Check for column number mismatch
        if (   [self.abortOnColumnNumberMisMatchCheck state] == NSOnState
            && [csvColumns count] != [self.gpCatalogImportColumns.arrangedObjects count]) {
            NSAlert * errSheet = [NSAlert alertWithMessageText:@"Import Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Number of fields specified do not match the number of colums found in CSV file.  Column count=%ld  selected field count=%ld", [csvColumns count], [self.gpCatalogImportColumns.arrangedObjects count]];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            return NO;
        }
        if ([csvColumns count] > [self.gpCatalogImportColumns.arrangedObjects count]) {
            NSAlert * errSheet = [NSAlert alertWithMessageText:@"Import Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"Not enough fields specified for the number of colums found in CSV file.  Column count=%ld  selected field count=%ld", [csvColumns count], [self.gpCatalogImportColumns.arrangedObjects count]];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            
            return NO;
        }
        
        // Create a new GPCatalog entry for this row/line
        GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
        self.addCount++;
        
        for (NSUInteger i=0; i<[self.gpCatalogImportColumns.arrangedObjects count]; i++) {
            // If the column is marked as NOT_AVAILABLE, do not set the model property (leave nil).
            if ([csvColumns[i] isEqualToString:NOT_AVAILABLE]) continue;
            
            NSPropertyDescription * prop = self.gpCatalogImportColumns.arrangedObjects[i];
            
            // If this is the GPID field, parse out the major variety/subvariety info.
            if ([prop.name isEqualToString:GPID_FIELD]) {
                NSScanner * gpidScanner = [[NSScanner alloc] initWithString:csvColumns[i]];
                [gpidScanner setCharactersToBeSkipped:hyphenCharSet];
                
                // Scan past the country ID
                // TODO: Set the gpCatalog's country ID from this.
                NSString * countryID;
                [gpidScanner scanUpToCharactersFromSet:hyphenCharSet intoString:&countryID];
                
                // Scan the section ID.
                [gpidScanner scanUpToCharactersFromSet:hyphenCharSet intoString:&workingSectionID];
                
                NSString * gpidMarjorVarietyNumber;
                [gpidScanner scanUpToCharactersFromSet:hyphenCharSet intoString:&gpidMarjorVarietyNumber];
                
                // If this is the end of the GPID, it's a major variety.
                // If not, it's a subvariety.
                if ([gpidScanner isAtEnd]) {
                    workingMajorVariety = entry;
                }
                else {
                    // Scan the thee letter achronym subvariety denotation.
                    NSString * subvarietyDenoter;
                    [gpidScanner scanUpToCharactersFromSet:hyphenCharSet intoString:&subvarietyDenoter];
                    
                    // Ensure the front part of the GPID matches with the current
                    // working major variety.  If they match, set as a subvariety.
                    NSString * majorIDofSUB = [NSString stringWithFormat:@"%@-%@-%@", countryID, workingSectionID, gpidMarjorVarietyNumber];
                    
                    if (   [majorIDofSUB isEqualToString:workingMajorVariety.gp_catalog_number]
                        && (   [subvarietyDenoter isEqualToString:SUBVARIETY_GPID]
                            || [subvarietyDenoter isEqualToString:EXPERT_SUBVARIETY_GPID])
                        ) {
                        workingMajorVariety.has_subvarieties = @(YES);
                        [workingMajorVariety addSubvarietiesObject:entry];
                    }
                    // If there is not a match, then the subvarieties are NOT in
                    // order with the major variety (the major must always immiadeatly
                    // preceed the subs).
                    else {
                        // For now, do not import these entries.
                        // Log the skip information.
                        NSLog(@"GPID %@ could not be mapped to a major variety.  Skipping insertion.", csvColumns[i]);
                        [self.managedObjectContext deleteObject:entry];
                        
                        skipCount++;
                    }
                }
            }
            
            if ([prop isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeDescription * att = (NSAttributeDescription *)prop;
                
                if (   att.attributeType == NSInteger16AttributeType
                    || att.attributeType == NSInteger32AttributeType
                    || att.attributeType == NSBooleanAttributeType) {
                    NSInteger iVal = [csvColumns[i] integerValue];
                    [entry setValue:@(iVal) forKey:att.name];
                }
                else if (att.attributeType == NSStringAttributeType) {
                    [entry setValue:csvColumns[i] forKey:att.name];
                }
                else if (att.attributeType == NSDateAttributeType) {
                    NSDate * date = [dateFormatter dateFromString:csvColumns[i]];
                    [entry setValue:date forKey:att.name];
                }
            }
            else if ([prop isKindOfClass:[NSRelationshipDescription class]]) {
                // First check if relationship objects should be created where none exist.
                if ([self.createRelatedObjectsCheck state] == NSOffState) continue;
                
                NSRelationshipDescription * rel = (NSRelationshipDescription *)prop;
                if ([rel.name isEqualToString:@"country"]) {
                    Country * country = [self.countries objectForKey:csvColumns[i]];
                    
                    // If the model does not exist, create it.
                    if (country == nil) {
                        country = [NSEntityDescription insertNewObjectForEntityForName:@"Country" inManagedObjectContext:self.managedObjectContext];
                        country.country_name = csvColumns[i];
                        country.country_sort_id = @([self.countries count] - 1);
                        
                        [self.countries setValue:country forKey:country.country_name];
                    }
                    
                    entry.country = country;
                }
                else if ([rel.name isEqualToString:@"formatType"]) {
                    Format * format = [self.formatTypes objectForKey:csvColumns[i]];
                    
                    // If the model does not exist, create it.
                    if (format == nil) {
                        format = [NSEntityDescription insertNewObjectForEntityForName:@"Format" inManagedObjectContext:self.managedObjectContext];
                        format.formatName = csvColumns[i];
                        
                        [self.formatTypes setValue:format forKey:format.formatName];
                    }
                    
                    entry.formatType = format;
                }
                else if ([rel.name isEqualToString:@"catalogGroup"]) {
                    GPCatalogGroup * catalogGroup = [self.catalogGroups objectForKey:csvColumns[i]];
                    
                    // If the model does not exist, create it.
                    if (catalogGroup == nil) {
                        catalogGroup = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogGroup" inManagedObjectContext:self.managedObjectContext];
                        catalogGroup.group_name = csvColumns[i];
                        catalogGroup.group_number = workingSectionID;
                        
                        [self.catalogGroups setValue:catalogGroup forKey:catalogGroup.group_name];
                    }
                    
                    entry.catalogGroup = catalogGroup;
                }
            }
        }
    }
    
    //NSLog(@"save");
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
        NSLog(@"ERROR saving during export %@ %@", error, error.userInfo);
        return NO;
    }
    
    if (skipCount > 0) {
        NSAlert * errSheet = [NSAlert alertWithMessageText:@"Import Error" defaultButton:nil alternateButton:nil otherButton:nil informativeTextWithFormat:@"%ld GP catalog entries could not be matched to a major variety.  Refer to the log for a full listing of skipped GPIDs.", skipCount];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        
        self.addCount = self.addCount - skipCount;
        return NO;
    }
    
    return YES;
}


- (IBAction)importIntoGPCatalog:(id)sender {
    [self.finishedLabel setHidden:YES];
    [self.progressIndicator startAnimation:sender];
    
    BOOL rc = [self doImportGPCatalog];
    
    [self.progressIndicator stopAnimation:sender];
    
    if (rc == YES) {
        NSString * formattedAddCount = [NSString stringWithFormat:@"%ld entries added!", self.addCount];
        [self.finishedLabel setStringValue:formattedAddCount];
        [self.finishedLabel setHidden:NO];
    }
}

- (IBAction)done:(id)sender {
    [self.window performClose:sender];
}

@end
