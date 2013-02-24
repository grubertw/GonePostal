//
//  BureauPrecancel.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface BureauPrecancel : NSManagedObject

@property (nonatomic, retain) NSString * cancel_style;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSString * pss_type;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;

@end
