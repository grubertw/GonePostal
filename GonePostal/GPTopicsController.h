//
//  GPTopicsController.h
//  GonePostal
//
//  Created by Travis Gruber on 2/24/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPTopicsController : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * modelController;

- (IBAction)addTopic:(id)sender;
- (IBAction)removeTopic:(id)sender;

@end
