//
//  NSPersistentDocument+FileWrapperSupport.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

/*
 We need to bypass what NSPersistentDocument does in setFileURL:, but we do want to use the functionality provided by NSDocument's implementation of that method. To achieve this, we create a simple category on NSPersistentDocument with methods that will call the NSDocument version of the method. Then, our subclass will call the category method where it would normally simply call the super implementation.
 */
@interface NSPersistentDocument (FileWrapperSupport)

- (void)simpleSetFileURL:(NSURL *)fileURL;

@end
