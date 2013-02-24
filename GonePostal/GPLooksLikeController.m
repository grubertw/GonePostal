//
//  GPLooksLikeController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPLooksLikeController.h"
#import "LooksLike.h"

@interface GPLooksLikeController ()

@end

@implementation GPLooksLikeController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *looksLikeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        self.looksLikeSortDescriptors = @[looksLikeSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Edit Looks Like";
}

- (IBAction)addLooksLike:(id)sender {
    [self.looksLikeController insert:sender];
}

- (IBAction)removeLooksLike:(id)sender {
    [self.looksLikeController remove:sender];
}


@end
