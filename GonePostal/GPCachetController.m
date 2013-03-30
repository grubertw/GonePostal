//
//  GPCachetController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCachetController.h"
#import "GPDocument.h"
#import "Cachet.h"

@interface GPCachetController ()

@property (strong, nonatomic) GPDocument * gpDocument;

@end

@implementation GPCachetController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        self.gpDocument = doc;
        
        self.managedObjectContext = doc.managedObjectContext;
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        GPDocument * doc = [docController currentDocument];
        self.gpDocument = doc;
        self.managedObjectContext = doc.managedObjectContext;
        
        NSSortDescriptor *cachetNameSort = [[NSSortDescriptor alloc] initWithKey:@"cachet_catalog_name" ascending:YES];
        self.cachetCatalogNameSortDescriptors = @[cachetNameSort];
        
        NSSortDescriptor *cachetMakerSort = [[NSSortDescriptor alloc] initWithKey:@"cachet_maker_name" ascending:YES];
        self.cachetMakerNameSortDescriptors = @[cachetMakerSort];
    }
    
    return self;
}

- (IBAction)addDefaultPicture:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.representedObject;
    [cachet setCachet_picture:fileName];
}

- (IBAction)addAlternatePicture1:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    NSString * fileName = [self.gpDocument addPictureToWrapper];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    Cachet * cachet = self.cachetController.content;
    cachet.alternate_picture_6 = fileName;
}

@end
