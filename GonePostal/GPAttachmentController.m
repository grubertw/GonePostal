//
//  GPAttachmentController.m
//  GonePostal
//
//  Created by Travis Gruber on 6/29/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPAttachmentController.h"
#import "Attachment.h"
#import "GPDocument.h"
#import "GPPDFViewController.h"

@interface GPAttachmentController ()
@property (strong, nonatomic) IBOutlet NSArrayController * attachementController;

@end

@implementation GPAttachmentController

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *attachmentSort = [[NSSortDescriptor alloc] initWithKey:@"gp_attachment_number" ascending:YES];
        _attachmentSortDescriptors = @[attachmentSort];
        
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_name" ascending:YES];
        _countrySortDescriptors = @[countrySort];
        
        NSSortDescriptor *subjectSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _subjectSortDescriptors = @[subjectSort];
        
        NSSortDescriptor *salesGroupSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _salesGroupSortDescriptors = @[salesGroupSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"PDF Library";
}

- (IBAction)viewDocument:(id)sender {
    if (!self.attachementController.selectedObjects) return;
    Attachment * atthmnt = self.attachementController.selectedObjects[0];
    
    GPPDFViewController * controller = [[GPPDFViewController alloc] initWithAttachment:atthmnt];
    [[self document] addWindowController:controller];
    [controller.window makeKeyAndOrderFront:sender];
}

- (IBAction)importPDF:(id)sender {
    if (!self.attachementController.selectedObjects) return;
    Attachment * atthmnt = self.attachementController.selectedObjects[0];
    
    GPDocument * doc = [self document];
    atthmnt.filename = [doc addFileToWrapperUsingGPID:atthmnt.gp_attachment_number forAttribute:@"Attachment" fileType:GPImportFileTypePDF];
}

- (IBAction)addAttachment:(id)sender {
    [self.attachementController insert:sender];
    [self.managedObjectContext save:nil];
}

- (IBAction)removeAttachment:(id)sender {
    [self.attachementController remove:sender];
    [self.managedObjectContext save:nil];
}

@end
