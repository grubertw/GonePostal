//
//  GPAddSubvariety.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/10/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "GPCatalogEditor.h"

@interface GPAddSubvariety : NSWindowController <NSWindowDelegate>

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (weak, nonatomic) GPCatalogEditor * catalogEditor;

@property (strong, nonatomic) GPCatalog * theMajorVariety;

@property (strong, nonatomic) NSArray * formatsSortDescriptors;
@property (strong, nonatomic) NSArray * altCatalogsSortDescriptors;

@property (weak, nonatomic) IBOutlet NSObjectController * gpCatalogEntryController;

@property (weak, nonatomic) IBOutlet NSTextField * quantityInput;

- (IBAction)addSubvarieties:(id)sender;
- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)addDefaultPicture:(id)sender;
- (IBAction)addAlternatePicture1:(id)sender;
- (IBAction)addAlternatePicture2:(id)sender;
- (IBAction)addAlternatePicture3:(id)sender;
- (IBAction)addAlternatePicture4:(id)sender;
- (IBAction)addAlternatePicture5:(id)sender;
- (IBAction)addAlternatePicture6:(id)sender;

@end
