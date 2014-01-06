//
//  Cancelations.h
//  GonePostal
//
//  Created by Travis Gruber on 1/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, GPSalesGroup;

@interface Cancelations : NSManagedObject

@property (nonatomic, retain) NSString * cancelation_description;
@property (nonatomic, retain) NSString * gp_cancelation_number;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) GPCatalog *gpCatlog;
@property (nonatomic, retain) GPSalesGroup *salesGroup;

@end
