//
//  GPCatalogPeople.h
//  GonePostal
//
//  Created by Travis Gruber on 1/22/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogPeopleType;

@interface GPCatalogPeople : NSManagedObject

@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) NSString * personName;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) GPCatalogPeopleType *peopleType;
@end

@interface GPCatalogPeople (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
