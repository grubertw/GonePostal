//
//  GPLooksLikeController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPLooksLikeController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * looksLikeSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * looksLikeController;

- (IBAction)addLooksLike:(id)sender;
- (IBAction)removeLooksLike:(id)sender;

@end
