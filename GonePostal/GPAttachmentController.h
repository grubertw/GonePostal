//
//  GPAttachmentController.h
//  GonePostal
//
//  Created by Travis Gruber on 6/29/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPAttachmentController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * attachmentSortDescriptors;
@property (strong, nonatomic) NSArray * countrySortDescriptors;
@property (strong, nonatomic) NSArray * subjectSortDescriptors;

@end
