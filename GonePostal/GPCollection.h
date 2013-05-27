//
//  GPCollection.h
//  GonePostal
//
//  Created by Travis Gruber on 5/16/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCollection, Stamp;

@interface GPCollection : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * value;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *wantLists;
@property (nonatomic, retain) GPCollection *wantTarget;
@property (nonatomic, retain) NSSet *sellLists;
@property (nonatomic, retain) GPCollection *sellTarget;
@end

@interface GPCollection (CoreDataGeneratedAccessors)

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addWantListsObject:(GPCollection *)value;
- (void)removeWantListsObject:(GPCollection *)value;
- (void)addWantLists:(NSSet *)values;
- (void)removeWantLists:(NSSet *)values;

- (void)addSellListsObject:(GPCollection *)value;
- (void)removeSellListsObject:(GPCollection *)value;
- (void)addSellLists:(NSSet *)values;
- (void)removeSellLists:(NSSet *)values;

@end
