//
//  GPFilenameTransformer.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPFilenameTransformer.h"
#import "GonePostal-Swift.h"

@implementation GPFilenameTransformer

// The complete path within the file wrapper will be returned as a string.
+ (Class)transformedValueClass { return [NSString class]; }

+ (BOOL)allowsReverseTransformation { return NO; }

// Initialze the transformer with a reference to the GPDocument.
- (id)initWithDocument:(GPDocument *)doc {
    self = [super init];
    if (self) {
        self.document = doc;
    }
    return self;
}

// Return the complete file path for the filename,
// based on the location of the file wrapper.
// files within GPWrapper are only one level deep.
// (There are only pictures and the SQLite database file).
- (id)transformedValue:(id)value {
    if (value == nil) return nil;
    
    NSString * gpWrapperPath = [[self.document fileURL] path];
    NSString * absolutePath = [gpWrapperPath stringByAppendingPathComponent:value];
    
    return absolutePath;
}

@end
