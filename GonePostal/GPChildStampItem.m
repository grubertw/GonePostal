//
//  GPChildStampItem.m
//  GonePostal
//
//  Created by Travis Gruber on 3/25/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPChildStampItem.h"
#import "GPDocument.h"
#import "GPStampDetail.h"
#import "Stamp.h"

@interface GPChildStampItem ()
@property (strong, nonatomic) GPDocument * doc;
@end

@implementation GPChildStampItem

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
    }
    return self;
}

-(IBAction)showStampDetail:(id)sender {
    Stamp * stamp = self.representedObject;
    
    GPStampDetail * sd = [[GPStampDetail alloc] initWithStamp:stamp];
    [self.doc addWindowController:sd];
    [sd.window makeKeyAndOrderFront:sender];
}

@end
