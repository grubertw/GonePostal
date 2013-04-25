//
//  GPSubvarietySearch.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPSubvarietySearch : NSViewController
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;
@property (strong, nonatomic) NSPredicate * predicate;

@property (strong, nonatomic) NSPanel * panel;

- (id)initWithPredicate:(NSPredicate *)predicate forStamp:(bool)isStampPredicate;
@end
