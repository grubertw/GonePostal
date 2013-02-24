//
//  PictureType.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPPicture;

@interface PictureType : NSManagedObject

@property (nonatomic, retain) NSString * picture_type;
@property (nonatomic, retain) NSSet *pictures;
@end

@interface PictureType (CoreDataGeneratedAccessors)

- (void)addPicturesObject:(GPPicture *)value;
- (void)removePicturesObject:(GPPicture *)value;
- (void)addPictures:(NSSet *)values;
- (void)removePictures:(NSSet *)values;

@end
