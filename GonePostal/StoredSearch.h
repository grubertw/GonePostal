//
//  StoredSearch.h
//  GonePostal
//
//  Created by Travis Gruber on 2/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface StoredSearch : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSPredicate * predicate;
@property (nonatomic, retain) NSNumber * identifier;

@end
