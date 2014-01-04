//
//  PriceList.h
//  GonePostal
//
//  Created by Travis Gruber on 8/19/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCollection, Valuation;

@interface PriceList : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * listDescription;
@property (nonatomic, retain) NSSet *values;
@property (nonatomic, retain) NSSet *collectionsUsingList;
@end

@interface PriceList (CoreDataGeneratedAccessors)

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

- (void)addCollectionsUsingListObject:(GPCollection *)value;
- (void)removeCollectionsUsingListObject:(GPCollection *)value;
- (void)addCollectionsUsingList:(NSSet *)values;
- (void)removeCollectionsUsingList:(NSSet *)values;

@end
