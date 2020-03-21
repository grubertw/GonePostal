//
//  GPFilenameTransformer.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GPDocument;

@interface GPFilenameTransformer : NSValueTransformer

@property (strong, nonatomic) GPDocument * document;

// Initialze the transformer with a reference to the GPDocument.
- (id)initWithDocument:(GPDocument *)doc;

@end
