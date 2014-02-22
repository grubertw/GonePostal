//
//  GPPlateSizeType.h
//  GonePostal
//
//  Created by Travis Gruber on 2/17/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPPlateSize;

@interface GPPlateSizeType : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *plateSizes;
@end

@interface GPPlateSizeType (CoreDataGeneratedAccessors)

- (void)addPlateSizesObject:(GPPlateSize *)value;
- (void)removePlateSizesObject:(GPPlateSize *)value;
- (void)addPlateSizes:(NSSet *)values;
- (void)removePlateSizes:(NSSet *)values;

@end
