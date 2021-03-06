//
//  GPCachetController.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPCachetController : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * cachetCatalogNameSortDescriptors;
@property (strong, nonatomic) NSArray * cachetMakerNameSortDescriptors;
@property (strong, nonatomic) NSArray * salesGroupSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * cachetController;

@end
