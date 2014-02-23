//
//  GPCatalogQuantityController.h
//  GonePostal
//
//  Created by Travis Gruber on 2/23/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPCatalogQuantityController : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@end
