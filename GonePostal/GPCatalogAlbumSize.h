//
//  GPCatalogAlbumSize.h
//  GonePostal
//
//  Created by Travis Gruber on 1/3/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, StampFormat;

@interface GPCatalogAlbumSize : NSManagedObject

@property (nonatomic, retain) NSNumber * albumWidth;
@property (nonatomic, retain) NSNumber * albumHeight;
@property (nonatomic, retain) NSString * mountSize;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) GPCatalog *catalogEntry;
@property (nonatomic, retain) StampFormat *format;

@end
