//
//  GPStampExamples.m
//  GonePostal
//
//  Created by Travis Gruber on 4/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampExamples.h"
#import "Stamp.h"
#import "GPDocument.h"
#import "GPStampDetail.h"

@interface GPStampExamples ()
@property (weak, nonatomic) IBOutlet NSTableView * stampExamplesTable;
@property (strong, nonatomic) IBOutlet NSArrayController * stampExamplesController;

@end

@implementation GPStampExamples

- (id)initWithGPCatalog:(GPCatalog *)gpCatalog {
    self = [super initWithWindowNibName:@"GPStampExamples"];
    if (self) {
        _gpCatalog = gpCatalog;
        _managedObjectContext = gpCatalog.managedObjectContext;
        
        NSSortDescriptor *stampSort = [[NSSortDescriptor alloc] initWithKey:@"gpCatalog.gp_catalog_number" ascending:YES];
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _stampSortDescriptors = @[stampSort, formatSort];
    }
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
  
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    NSString * catalogExamples = [NSString stringWithFormat:@"Example Stamps for GPID %@", self.gpCatalog.gp_catalog_number];
    return catalogExamples;
}

- (IBAction)addStampExample:(id)sender {
    Stamp * stamp = [NSEntityDescription insertNewObjectForEntityForName:@"Stamp" inManagedObjectContext:self.managedObjectContext];
    
    [stamp setGpCatalog:self.gpCatalog];
    [stamp setDefault_picture:self.gpCatalog.default_picture];
    
    [self.stampExamplesController addObject:stamp];
}

- (IBAction)removeStampExample:(id)sender {
    [self.stampExamplesController remove:sender];
}

- (IBAction)showDetail:(NSButton *)sender {
    NSInteger row = [self.stampExamplesTable rowForView:sender];
    Stamp * stamp = self.stampExamplesController.arrangedObjects[row];
    
    GPStampDetail * sd = [[GPStampDetail alloc] initWithStamp:stamp isExample:YES];
    [self.document addWindowController:sd];
    [sd.window makeKeyAndOrderFront:sender];
}

- (IBAction)close:(id)sender {
    [self.window performClose:sender];
}

@end