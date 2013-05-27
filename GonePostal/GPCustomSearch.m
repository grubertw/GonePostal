//
//  GPCusomSearch.m
//  GonePostal
//
//  Created by Travis Gruber on 5/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCustomSearch.h"
#import "GPDocument.h"

@interface GPCustomSearch ()
@property (strong, nonatomic) NSNumber * searchID;
@property (strong, nonatomic) IBOutlet NSArrayController * customSearchController;

@property (weak, nonatomic) IBOutlet NSPredicateEditor * predicateEditor;
@property (strong, nonatomic) IBOutlet NSPredicateEditorRowTemplate *compoundTemplate;

@property (strong, nonatomic) StoredSearch * currSearch;
@end

@implementation GPCustomSearch

- initWithStoredSearchIdentifier:(NSNumber *)identifier {
    self = [super initWithWindowNibName:@"GPCustomSearch"];
    if (self) {
        _searchID = identifier;
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        NSSortDescriptor *customSearchSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _customSearchSortDescriptors = @[customSearchSort];
    }
    return self;
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Edit Custom Search";
}

- (void)windowDidLoad {
    [super windowDidLoad];
    
    NSPredicate * pred = [NSPredicate predicateWithFormat:@"identifier == %ld",[self.searchID integerValue]];
    
    [self.customSearchController setFetchPredicate:pred];
    [self.customSearchController fetch:self];
}

- (void)tableViewSelectionDidChange:(NSNotification *)aNotification {
    if (self.currSearch && self.predicateEditor.objectValue) {
        self.currSearch.predicate = self.predicateEditor.objectValue;
        
        NSError * error;
        if (![self.managedObjectContext save:&error]) {
            NSAlert * errSheet = [NSAlert alertWithError:error];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [self.managedObjectContext undo];
        }
    }
    
    if (self.customSearchController.selectedObjects.count == 0) return;
    
    StoredSearch * storedSearch = self.customSearchController.selectedObjects[0];
    self.currSearch = storedSearch;
    
    NSMutableArray * expressions = [[NSMutableArray alloc] initWithCapacity:0];
    
    NSMutableArray * availableTemplates = [[NSMutableArray alloc] initWithCapacity:0];
    [availableTemplates addObject:self.compoundTemplate];
    
    NSPredicateEditorRowTemplate * predicateTemplate;
    NSPopUpButton * lhsButton;
    NSMenuItem * menuItem;
    NSUInteger count = 0;
    
    if ([storedSearch.identifier isEqualToNumber:@(CUSTOM_GP_CATALOG_SEARCH_ID)]) {
        [expressions addObject:[NSExpression expressionForKeyPath:@"background_information"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"color"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"denomination"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"design_measurement"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"designers"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"engravers"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gp_catalog_number"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gp_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gum"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"identification_notes"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"issue_location"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"issue_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"long_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"paper_color"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"paper_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"perforation"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"perforation_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"plate_variation_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"press"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"print"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"printer"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"series"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"surcharge_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"tag"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"variety_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"watermark"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"catalogGroup.group_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"country.country_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"formatType.formatName"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"subvarietyType.acronym"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSStringAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSLikePredicateOperatorType), @(NSContainsPredicateOperatorType),@(NSMatchesPredicateOperatorType), @(NSBeginsWithPredicateOperatorType), @(NSEndsWithPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Background Information"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Color"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Denomination"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Design Measurement"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Designers"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Engravers"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"GPID"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Short Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Gum"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Identification Notes"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Issue Location"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Issue Name"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Long Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Paper Color"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Paper Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Perforation"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Perforation Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Variation Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Press"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Print"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Printer"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Series"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Surcharge Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Tagging"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Variety Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Watermark"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Section"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Country"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Format Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Subvariety Type"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"alternateCatalogs.alternate_catalog_number"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"alternateCatalogs.alternateCatalogName.alternate_catalog_name"]];
        
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSStringAttributeType modifier:NSAnyPredicateModifier operators:@[@(NSLikePredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Number"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Name"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"album_height"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"album_width"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"number_of_panes"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"number_of_plates"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"pane_size"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"plate_block_quantity"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"plate_size"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"quantity_ordered"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"quantity_printed"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"quantity_sold"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSInteger32AttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType), @(NSNotEqualToPredicateOperatorType), @(NSLessThanPredicateOperatorType), @(NSLessThanOrEqualToPredicateOperatorType), @(NSGreaterThanPredicateOperatorType), @(NSGreaterThanOrEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Album Height"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Album Width"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Number of Panes"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Number of Plates"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Pane Size"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Block Quantity"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Size"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Quantity Ordered"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Quantity Printed"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Quantity Sold"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"number_of_plates_used"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"variety_type"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSInteger16AttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType), @(NSNotEqualToPredicateOperatorType), @(NSLessThanPredicateOperatorType), @(NSLessThanOrEqualToPredicateOperatorType), @(NSGreaterThanPredicateOperatorType), @(NSGreaterThanOrEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Album Height"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Album Width"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"date_documented_first_use"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"date_issued"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSDateAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType),@(NSNotEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Date Documented First Use"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Date Issued"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"has_subvarieties"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"is_custum"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"is_default"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"printing_on_back"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSBooleanAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType),@(NSNotEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Has Subvarieties"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"User Catalog"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Show Default Catalog"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Printing on Back"];
        
    }
    else if ([storedSearch.identifier isEqualToNumber:@(CUSTOM_STAMP_SEARCH_ID)]) {
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.color"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.denomination"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.design_measurement"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.designers"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.engravers"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.gp_catalog_number"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.gp_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.gum"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.issue_location"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.issue_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.long_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.paper_color"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.paper_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.perforation"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.perforation_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.plate_variation_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.press"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.print"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.printer"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.series"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.surcharge_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.tag"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.variety_description"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.watermark"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.catalogGroup.group_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.country.country_name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.formatType.formatName"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"address_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"cancelation_type"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"census_id"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"certificates"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"faults"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"history"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"notes"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"plate_location"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"plate_position"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"source"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"cancelQuality.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"centering.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"dealer.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"format.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"grade.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"gumCondition.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"hinged.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"location.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"lot.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"mount.name"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"soundness.name"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSStringAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSLikePredicateOperatorType), @(NSContainsPredicateOperatorType),@(NSMatchesPredicateOperatorType), @(NSBeginsWithPredicateOperatorType), @(NSEndsWithPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Color"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Denomination"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Design Measurement"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Designers"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Engravers"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"GPID"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Short Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Gum"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Issue Location"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Issue Name"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Long Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Paper Color"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Paper Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Perforation"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Perforation Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Variation Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Press"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Print"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Printer"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Series"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Surcharge Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Tagging"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Variety Description"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Watermark"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Section"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Country"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Format Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Address Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Cancelation Type"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Census ID"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Certificates"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Faults"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"History"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Notes"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Location"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Plate Position"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Source"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Cancel Quality"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Centering"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Dealer"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Format"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Grade"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Gum Condition"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Hinged"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Location"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Lot"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Mount"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Soundness"];
        
        
        
//        expressions = [[NSMutableArray alloc] initWithCapacity:0];
//        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.alternateCatalogs.alternate_catalog_number"]];
//        [expressions addObject:[NSExpression expressionForKeyPath:@"gpCatalog.alternateCatalogs.alternateCatalogName.alternate_catalog_name"]];
//        
//        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSStringAttributeType modifier:NSAnyPredicateModifier operators:@[@(NSLikePredicateOperatorType)] options:0];
//        [availableTemplates addObject:predicateTemplate];
//        
//        count = 0;
//        lhsButton = predicateTemplate.templateViews[0];
//        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Number"];
//        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Catalog Name"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"last_sale_price"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"manual_value"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"purchase_amount"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSFloatAttributeType modifier:NSDirectPredicateModifier operators:@[ @(NSLessThanPredicateOperatorType), @(NSLessThanOrEqualToPredicateOperatorType), @(NSGreaterThanPredicateOperatorType), @(NSGreaterThanOrEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Last Sale Price"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Manual Value"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Purchase Amount"];
        
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"mint_used"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSBooleanAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType),@(NSNotEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Mint"];
        
        
        expressions = [[NSMutableArray alloc] initWithCapacity:0];
        [expressions addObject:[NSExpression expressionForKeyPath:@"cancelation_date"]];
        [expressions addObject:[NSExpression expressionForKeyPath:@"purchase_date"]];
        predicateTemplate = [[NSPredicateEditorRowTemplate alloc] initWithLeftExpressions:expressions rightExpressionAttributeType:NSDateAttributeType modifier:NSDirectPredicateModifier operators:@[@(NSEqualToPredicateOperatorType),@(NSNotEqualToPredicateOperatorType)] options:0];
        [availableTemplates addObject:predicateTemplate];
        
        count = 0;
        lhsButton = predicateTemplate.templateViews[0];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Cancelation Date"];
        menuItem = lhsButton.itemArray[count++];    [menuItem setTitle:@"Purchase Date"];
    }
    
    [self.predicateEditor setRowTemplates:availableTemplates];
    [self.predicateEditor setObjectValue:storedSearch.predicate];
    
    // If the predicate is empty, add the first row(s) for the user.
    if (!storedSearch.predicate) {
        [self.predicateEditor addRow:self];
    }
}

- (IBAction)addCustomSearch:(id)sender {
    StoredSearch * customSearch = [NSEntityDescription insertNewObjectForEntityForName:@"StoredSearch" inManagedObjectContext:self.managedObjectContext];
    customSearch.identifier = self.searchID;
    customSearch.name = @"New Search";
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
    
    [self.customSearchController fetch:sender];
}

- (IBAction)removeCustomSearch:(id)sender {
    [self.customSearchController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)saveSearch:(id)sender {
    if (self.currSearch && self.predicateEditor.objectValue) {
        self.currSearch.predicate = self.predicateEditor.objectValue;
        
        NSError * error;
        if (![self.managedObjectContext save:&error]) {
            NSAlert * errSheet = [NSAlert alertWithError:error];
            [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [self.managedObjectContext undo];
        }
    }
    
    [self.window performClose:sender];
}

@end
