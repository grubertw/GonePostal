//
//  GPCatalogDate.h
//  GonePostal
//
//  Created by Travis Gruber on 2/21/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPCatalogDateType;

@interface GPCatalogDate : NSManagedObject

@property (nonatomic, retain) NSDate * catalogDate;
@property (nonatomic, retain) NSNumber * dayExact;
@property (nonatomic, retain) NSString * details;
@property (nonatomic, retain) NSNumber * monthExact;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) GPCatalogDateType *dateType;
@end

@interface GPCatalogDate (CoreDataGeneratedAccessors)

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

@end
