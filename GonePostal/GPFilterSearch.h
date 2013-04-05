//
//  GPFilterSearch.h
//  GonePostal
//
//  Created by Travis Gruber on 3/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPFilterSearch : NSViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSNumber * filterSearchEnabled;
@property (strong, nonatomic) NSNumber * filterByAlwaysDisplay;
@property (strong, nonatomic) NSNumber * filterByVeryRare;
@property (strong, nonatomic) NSNumber * filterByHidden;
@property (strong, nonatomic) NSNumber * filterByPlated;
@property (strong, nonatomic) NSNumber * filterBySurcharged;
@property (strong, nonatomic) NSNumber * filterByColorVariety;
@property (strong, nonatomic) NSNumber * filterByGumVariety;
@property (strong, nonatomic) NSNumber * filterByPlateVariety;
@property (strong, nonatomic) NSNumber * filterByTagVariety;
@property (strong, nonatomic) NSNumber * filterByPrintVariety;
@property (strong, nonatomic) NSNumber * filterByWatermarkVariation;
@property (strong, nonatomic) NSNumber * filterByColorError;
@property (strong, nonatomic) NSNumber * filterByTagError;
@property (strong, nonatomic) NSNumber * filterByPlateError;
@property (strong, nonatomic) NSNumber * filterByPerfError;
@property (strong, nonatomic) NSNumber * filterByWatermarkError;
@property (strong, nonatomic) NSNumber * filterByMultipleTransfer;

@property (strong, nonatomic) NSString * filtersSelected;

@property (strong, nonatomic) NSPredicate * predicate;

@property (strong, nonatomic) NSPanel * panel;

- (id)initWithPredicate:(NSPredicate *)predicate;

@end
