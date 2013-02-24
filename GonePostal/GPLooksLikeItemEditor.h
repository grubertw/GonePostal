//
//  GPLooksLikeItemEditor.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/22/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface GPLooksLikeItemEditor : NSCollectionViewItem

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@property (strong, nonatomic) NSArray * gpCatalogEntriesSortDescriptors;

@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogsController;
@property (weak, nonatomic) IBOutlet NSObjectController * looksLikeController;

- (IBAction)addPicture:(id)sender;
- (IBAction)removeCatalogEntries:(id)sender;

@end
