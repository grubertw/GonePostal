//
//  GPPicture.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/8/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog, PictureType;

@interface GPPicture : NSManagedObject

@property (nonatomic, retain) NSNumber * is_default;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) PictureType *pictureType;

@end
