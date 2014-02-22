//
//  GPCatalogDateType.h
//  GonePostal
//
//  Created by Travis Gruber on 2/21/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalogDate;

@interface GPCatalogDateType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *catalogDates;
@end

@interface GPCatalogDateType (CoreDataGeneratedAccessors)

- (void)addCatalogDatesObject:(GPCatalogDate *)value;
- (void)removeCatalogDatesObject:(GPCatalogDate *)value;
- (void)addCatalogDates:(NSSet *)values;
- (void)removeCatalogDates:(NSSet *)values;

@end
