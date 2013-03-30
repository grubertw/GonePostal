//
//  GPLocationSearch.h
//  GonePostal
//
//  Created by Travis Gruber on 3/5/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPLocationSearch : NSViewController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSPredicate * predicate;

@property (strong, nonatomic) NSPanel * panel;

- (id)initWithPredicate:(NSPredicate *)predicate;

@end
