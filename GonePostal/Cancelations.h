//
//  Cancelations.h
//  GonePostal
//
//  Created by Travis Gruber on 4/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface Cancelations : NSManagedObject

@property (nonatomic, retain) NSString * cancelation_description;
@property (nonatomic, retain) NSString * gp_cancelation_number;
@property (nonatomic, retain) NSString * picture;
@property (nonatomic, retain) GPCatalog *gpCatlog;

@end
