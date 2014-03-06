//
//  GPStampExamples.m
//  GonePostal
//
//  Created by Travis Gruber on 4/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampExamples.h"
#import "Stamp+Create.h"
#import "SaleHistory+Create.h"
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
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _stampSortDescriptors = @[formatSort];
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
    Stamp * stamp = [Stamp CreateFromDefaultsUsingManagedObjectContext:self.managedObjectContext];
    [stamp setGpCatalog:self.gpCatalog];
    [stamp setGp_stamp_number:self.gpCatalog.gp_catalog_number];
    
    [self.stampExamplesController addObject:stamp];
    
    // Create a SaleHistory from the defaults.
    SaleHistory * sh = [SaleHistory createFromDefaultUsingManagedObjectContext:self.managedObjectContext];
    [stamp addSaleHistoryObject:sh];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
}

- (IBAction)removeStampExample:(id)sender {
    [self.stampExamplesController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
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
