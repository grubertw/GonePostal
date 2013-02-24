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

@property (weak, nonatomic) IBOutlet NSObjectController * cachetController;

- (IBAction)addDefaultPicture:(id)sender;
- (IBAction)addAlternatePicture1:(id)sender;
- (IBAction)addAlternatePicture2:(id)sender;
- (IBAction)addAlternatePicture3:(id)sender;
- (IBAction)addAlternatePicture4:(id)sender;
- (IBAction)addAlternatePicture5:(id)sender;
- (IBAction)addAlternatePicture6:(id)sender;

@end
