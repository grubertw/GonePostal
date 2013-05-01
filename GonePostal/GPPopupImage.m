//
//  GPPopupImage.m
//  GonePostal
//
//  Created by Travis Gruber on 4/27/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPopupImage.h"

@interface GPPopupImage ()
@end

@implementation GPPopupImage

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        _preferredEdge = @(0);
    }
    return self;
}

- (void)rightMouseDown:(NSEvent *)theEvent {
    NSRect imageFrame;
    imageFrame.size = self.image.size;
    
    NSImageView * popupImage = [[NSImageView alloc] initWithFrame:imageFrame];
    [popupImage setImage:self.image];
    
    NSViewController * popupImageController = [[NSViewController alloc] init];
    [popupImageController setView:popupImage];
    
    NSPopover * imagePopover = [[NSPopover alloc] init];
    [imagePopover setBehavior:NSPopoverBehaviorTransient];
    [imagePopover setContentViewController:popupImageController];
    
    [imagePopover showRelativeToRect:self.bounds ofView:self preferredEdge:[self.preferredEdge unsignedIntegerValue]];
}

@end
