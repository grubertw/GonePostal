//
//  GPCatalogPeopleType.h
//  GonePostal
//
//  Created by Travis Gruber on 2/17/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalogPeople;

@interface GPCatalogPeopleType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *peoples;
@end

@interface GPCatalogPeopleType (CoreDataGeneratedAccessors)

- (void)addPeoplesObject:(GPCatalogPeople *)value;
- (void)removePeoplesObject:(GPCatalogPeople *)value;
- (void)addPeoples:(NSSet *)values;
- (void)removePeoples:(NSSet *)values;

@end
