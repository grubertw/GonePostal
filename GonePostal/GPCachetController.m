//
//  GPCachetController.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCachetController.h"
#import "Cachet+CoreDataClass.h"
#import "GonePostal-Swift.h"

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
        
        NSSortDescriptor *salesGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _salesGroupSortDescriptors = @[salesGroupSort];
    }
    
    return self;
}

- (IBAction)addDefaultPicture:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"cachet_picture"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    [cachet setCachet_picture:fileName];
}

- (IBAction)addAlternatePicture1:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cachet.alternate_picture_1"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_1 = fileName;
}

- (IBAction)addAlternatePicture2:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cahcet.alternate_picture_2"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_2 = fileName;
}

- (IBAction)addAlternatePicture3:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cahcet.alternate_picture_3"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_3 = fileName;
}

- (IBAction)addAlternatePicture4:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cachet.alternate_picture_4"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_4 = fileName;
}

- (IBAction)addAlternatePicture5:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cachet.alternate_picture_5"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_5 = fileName;
}

- (IBAction)addAlternatePicture6:(id)sender {
    Cachet * cachet = self.representedObject;
    
    NSString * fileName = [self.gpDocument addImageToWrapperUsingGPID:cachet.gp_cachet_number forAttribute:@"Cachet.alternate_picture_6"];
    if (fileName == nil) return;
    
    // Save the filename to the model.
    cachet.alternate_picture_6 = fileName;
}

@end
