//
//  GPCatalogPeople.h
//  GonePostal
//
//  Created by Travis Gruber on 2/17/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogPeopleType;

@interface GPCatalogPeople : NSManagedObject

@property (nonatomic, retain) NSString * personName;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) GPCatalogPeopleType *peopleType;
@property (nonatomic, retain) NSSet *catalogEntries;
@end

@interface GPCatalogPeople (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
