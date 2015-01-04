//
//  GPAlbumSizeController.h
//  GonePostal
//
//  Created by Travis Gruber on 1/3/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPAlbumSizeController : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) NSArray * sortDescriptors;

@end
