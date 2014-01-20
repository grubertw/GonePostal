//
//  GPSalesGroupType.h
//  GonePostal
//
//  Created by Travis Gruber on 1/20/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPSalesGroup;

@interface GPSalesGroupType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *salesGroups;
@end

@interface GPSalesGroupType (CoreDataGeneratedAccessors)

- (void)addSalesGroupsObject:(GPSalesGroup *)value;
- (void)removeSalesGroupsObject:(GPSalesGroup *)value;
- (void)addSalesGroups:(NSSet *)values;
- (void)removeSalesGroups:(NSSet *)values;

@end
