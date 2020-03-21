//
//  GPPlateUsageChooser.m
//  GonePostal
//
//  Created by Travis Gruber on 3/17/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPPlateUsageChooser.h"
#import "PlateUsage.h"
#import "GonePostal-Swift.h"

@interface GPPlateUsageChooser ()

@end

@implementation GPPlateUsageChooser

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        _managedObjectContext = doc.managedObjectContext;
        
        NSSortDescriptor *platePositionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _sortDescriptors = @[platePositionsSort];
    }
    
    return self;
}

@end
