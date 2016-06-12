//
//  GPFilterSearch.m
//  GonePostal
//
//  Created by Travis Gruber on 3/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPFilterSearch.h"
#import "GPDocument.h"

@interface GPFilterSearch ()
@end

@implementation GPFilterSearch

// Parse the filterPredicate to find out the current filters
// used in the search.  Set attributes in this class to reflect
// the expressions in the predicate.
- (void)loadSearchAttributesFromPredicate {
    NSArray * comparisons;
    if ([self.predicate isMemberOfClass:[NSCompoundPredicate class]]) {
        comparisons = ((NSCompoundPredicate *)self.predicate).subpredicates;
    }
    else if ([self.predicate isMemberOfClass:[NSComparisonPredicate class]]) {
        comparisons = [NSArray arrayWithObject:self.predicate];
    }
    
    NSUInteger filterCount = 0;
    self.filtersSelected = @"none";
    
    for (NSUInteger i=0; i<comparisons.count; i++) {
        NSExpression * leftExpression = ((NSComparisonPredicate *) [comparisons objectAtIndex:i]).leftExpression;
        
        //NSLog(@"  comparison[%ld] is %@", i, leftExpression.keyPath);
        
        if ([leftExpression.keyPath isEqualToString:@"always_display"]) {
            self.filterByAlwaysDisplay = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"very_rare"]) {
            self.filterByVeryRare = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"hidden"]) {
            self.filterByHidden = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"plated"]) {
            self.filterByPlated = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"surcharged"]) {
            self.filterBySurcharged = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"color_variety"]) {
            self.filterByColorVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"gum_variety"]) {
            self.filterByGumVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"plate_variety"]) {
            self.filterByPlateVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"tag_variety"]) {
            self.filterByTagVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"print_variety"]) {
            self.filterByPrintVariety = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"watermark_variation"]) {
            self.filterByWatermarkVariation = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"color_error"]) {
            self.filterByColorError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"tag_error"]) {
            self.filterByTagError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"plate_error"]) {
            self.filterByPlateError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"perf_error"]) {
            self.filterByPerfError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"watermark_error"]) {
            self.filterByWatermarkError = [NSNumber numberWithBool:YES];
            filterCount++;
        }
        else if ([leftExpression.keyPath isEqualToString:@"multiple_transfer"]) {
            self.filterByMultipleTransfer = [NSNumber numberWithBool:YES];
            filterCount++;
        }
    }
    
    if (filterCount > 0) {
        self.filterSearchEnabled = [NSNumber numberWithBool:YES];
        
        if (filterCount > 1) {
            self.filtersSelected = @"some";
        }
        else {
            self.filtersSelected = @"one";
        }
    }
    
}

- (id)initWithPredicate:(NSPredicate *)predicate
{
    self = [super initWithNibName:@"GPFilterSearch" bundle:nil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        _predicate = predicate;
    }
    
    return self;
}

- (void)loadView {
    [super loadView];
    [self loadSearchAttributesFromPredicate];
}

- (IBAction)saveSearch:(id)sender {
    self.filtersSelected = @"none";
    
    if ([self.filterSearchEnabled isEqualToNumber:[NSNumber numberWithBool:YES]]) {
        NSMutableArray * predicates = [NSMutableArray arrayWithCapacity:20];
        
        if ([self.filterByAlwaysDisplay isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"always_display == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterByVeryRare isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"very_rare == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterByHidden isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"hidden == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterByPlated isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"plated == yes"];
            [predicates addObject:pred];
        }
        if ([self.filterBySurcharged isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"surcharged == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByColorVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"color_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByGumVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"gum_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPlateVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"plate_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByTagVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"tag_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPrintVariety isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"print_variety == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByWatermarkVariation isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"watermark_variation == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByColorError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"color_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByTagError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"tag_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPlateError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"plate_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByPerfError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"perf_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByWatermarkError isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"watermark_error == yes"];
            [predicates addObject:pred];
        }
        
        if ([self.filterByMultipleTransfer isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            NSPredicate * pred = [NSPredicate predicateWithFormat:@"multiple_transfer == yes"];
            [predicates addObject:pred];
        }
        
        if (predicates.count == 0) {
            self.predicate = nil;
        }
        else if (predicates.count == 1) {
            self.predicate = [predicates objectAtIndex:0];
            self.filtersSelected = @"one";
        }
        else if (predicates.count > 1) {
            self.predicate = [NSCompoundPredicate andPredicateWithSubpredicates:predicates];
            self.filtersSelected = @"some";
        }
    }
    else {
        self.predicate = nil;
    }
    
    // End the sheet.
    [self.panel.sheetParent endSheet:self.panel];
    [self.view.window close];
}

@end
