//
//  GPPictureTransformer.h
//  GonePostal
//
//  Created by Travis Gruber on 6/26/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPDocument;

@interface GPPictureTransformer : NSValueTransformer

- (id)initWithDocument:(GPDocument *)doc;

@end
