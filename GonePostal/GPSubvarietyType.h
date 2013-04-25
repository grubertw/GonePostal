//
//  GPSubvarietyType.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface GPSubvarietyType : NSManagedObject

@property (nonatomic, retain) NSString * acronym;
@property (nonatomic, retain) NSString * subDescription;
@property (nonatomic, retain) NSNumber * sortID;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@end

@interface GPSubvarietyType (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

@end
