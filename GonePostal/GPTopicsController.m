//
//  GPTopicsController.m
//  GonePostal
//
//  Created by Travis Gruber on 2/24/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPTopicsController.h"

@interface GPTopicsController ()

@end

@implementation GPTopicsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"topic_name" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Edit Topics";
}

- (IBAction)addTopic:(id)sender {
    [self.modelController insert:self];
    [self.managedObjectContext save:nil];
}

- (IBAction)removeTopic:(id)sender {
    [self.modelController remove:self];
    [self.managedObjectContext save:nil];
}

@end
