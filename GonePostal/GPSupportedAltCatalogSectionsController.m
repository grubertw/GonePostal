//
//  GPSupportedAltCatalogSectionsController.m
//  GonePostalX
//
//  Created by Travis Gruber on 1/23/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPSupportedAltCatalogSectionsController.h"
#import "AlternateCatalogGroup.h"

@interface GPSupportedAltCatalogSectionsController ()

@end

@implementation GPSupportedAltCatalogSectionsController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Create the sort descripors
        NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"sort_id" ascending:YES];
        self.sortDescriptors = @[sort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"Supported Catalog Sections";
}

- (IBAction)addAltCatalogSection:(id)sender {
    NSArray * models = [self.modelController arrangedObjects];
    
    int sortID = 0;
    
    if ([models count] > 0) {
        AlternateCatalogGroup * lastModel = (AlternateCatalogGroup *)[models lastObject];
        
        sortID = [lastModel.sort_id intValue] + 1;
    }
    
    AlternateCatalogGroup * newModel = [self.modelController newObject];
    [newModel setSort_id:[NSNumber numberWithInt:sortID]];
    
    [self.modelController addObject:newModel];
}

- (IBAction)deleteAltCatalogSectiom:(id)sender {
    [self.modelController remove:self];
}

- (IBAction)reSort:(id)sender {
    [self.modelController rearrangeObjects];
}

@end
