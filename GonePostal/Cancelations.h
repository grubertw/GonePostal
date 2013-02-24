//
//  Cancelations.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/15/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface Cancelations : NSManagedObject

@property (nonatomic, retain) NSString * cancelation_catalog_id;
@property (nonatomic, retain) NSString * cancelation_description;
@property (nonatomic, retain) GPCatalog *gpCatlog;

@end
