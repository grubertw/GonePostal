//
//  GPCountrySearch.h
//  GonePostal
//
//  Created by Travis Gruber on 3/4/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPCountrySearch : NSViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSPredicate * predicate;

@property (strong, nonatomic) NSMutableArray * itemsInSearch;
@property (strong, nonatomic) NSMutableArray * itemsNotInSearch;

@property (strong, nonatomic) NSPanel * panel;

- (id)initWithPredicate:(NSPredicate *)predicate forStamp:(bool)isStampPredicate;

@end
