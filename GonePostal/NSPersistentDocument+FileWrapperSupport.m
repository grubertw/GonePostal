//
//  NSPersistentDocument+FileWrapperSupport.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "NSPersistentDocument+FileWrapperSupport.h"

@implementation NSPersistentDocument (FileWrapperSupport)

// Forwards the message to NSDocument's setFileURL: (skips NSPersistentDocument's implementation).
- (void)simpleSetFileURL:(NSURL *)fileURL {
    [super setFileURL:fileURL];
}

@end
