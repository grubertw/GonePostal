//
//  GPCatalogDefaults.m
//  GonePostalX
//
//  Created by Travis Gruber on 2/3/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPCatalogDefaults.h"
#import "GPCatalog.h"
#import "GPDocument.h"
#import "AlternateCatalog.h"
#import "GPCatalogAlbumSize.h"

@interface GPCatalogDefaults ()
@property (weak, nonatomic) IBOutlet NSArrayController * allowedStampFormatsController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogDateController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogPeopleController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpPlateSizeController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogQuantityController;
@property (weak, nonatomic) IBOutlet NSArrayController * gpCatalogAlbumSizeController;

@property (weak, nonatomic) IBOutlet NSScrollView * scroller;
@property (strong, nonatomic) IBOutlet NSView * scrollContent;
@end

@implementation GPCatalogDefaults

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        NSSortDescriptor *countrySort = [[NSSortDescriptor alloc] initWithKey:@"country_sort_id" ascending:YES];
        _countriesSortDescriptors = @[countrySort];
        
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _formatsSortDescriptors = @[formatSort];
        
        NSSortDescriptor *gpGroupSort = [[NSSortDescriptor alloc] initWithKey:@"group_name" ascending:YES];
        _gpGroupsSortDescriptors = @[gpGroupSort];
        
        NSSortDescriptor *altCatalogSort = [[NSSortDescriptor alloc] initWithKey:@"alternate_catalog_name" ascending:YES];
        _altCatalogsSortDescriptors = @[altCatalogSort];
        
        NSSortDescriptor *altCatalogSectionsSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _altCatalogSectionsSortDescriptors = @[altCatalogSectionsSort];
        
        NSSortDescriptor *gpCatalogDateSort = [[NSSortDescriptor alloc] initWithKey:@"dateType.name" ascending:YES];
        _gpCatalogDateSortDescriptors = @[gpCatalogDateSort];
        
        NSSortDescriptor *gpCatalogPeopleSort = [[NSSortDescriptor alloc] initWithKey:@"peopleType.name" ascending:YES];
        _gpCatalogPeopleSortDescriptors = @[gpCatalogPeopleSort];
        
        NSSortDescriptor *gpCatalogPlateSizeSort = [[NSSortDescriptor alloc] initWithKey:@"plateSizeType.name" ascending:YES];
        _gpCatalogPlateSizeSortDescriptors = @[gpCatalogPlateSizeSort];
        
        NSSortDescriptor *gpCatalogQuantitySort = [[NSSortDescriptor alloc] initWithKey:@"quantityType.name" ascending:YES];
        _gpCatalogQuantitySortDescriptors = @[gpCatalogQuantitySort];
        
        NSSortDescriptor *gpCatalogAlbumSizeSort = [[NSSortDescriptor alloc] initWithKey:@"format.name" ascending:YES];
        _gpCatalogAlbumSizeSortDescriptors = @[gpCatalogAlbumSizeSort];
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    // Fetch and load the defaults.  If they do not exist, create them.
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setEntity:entity];
    
    NSPredicate *query = [NSPredicate predicateWithFormat:@"is_default == YES"];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    
    NSArray *results = [self.managedObjectContext executeFetchRequest:fetchRequest error:&error];
    if (results == nil) {
        NSLog(@"Error creating entry %@, %@", error, [error userInfo]);
        abort();
    }
    
    if (results.count == 1) {
        GPCatalog * defaults = [results objectAtIndex:0];
        [self.gpCatalogDefaultsController setContent:defaults];
        
        AlternateCatalog * defaultAltCatalog;
        for (AlternateCatalog * ac in defaults.alternateCatalogs) {
            defaultAltCatalog = ac;
            break;
        }
        
        self.selectedAltCatalogSection = defaultAltCatalog.alternateCatalogGroup;
    }
    else if (results.count == 0) {
        GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
        entry.is_default = [NSNumber numberWithBool:YES];
        
        // Create a row in the AlternateCatalogs table associated with the default.
        // The catalog number for the row is NOT specified.
        AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:self.managedObjectContext];
        [entry addAlternateCatalogsObject:altCatalog];
        
        [self.gpCatalogDefaultsController setContent:entry];
    }
    
    // Initialize the scroller
    [self.scroller setDocumentView:self.scrollContent];
    NSPoint newOrigin = NSMakePoint(0, NSMaxY([[self.scroller documentView] frame]) -
                                    [[self.scroller contentView] bounds].size.height);
    [[self.scroller documentView] scrollPoint:newOrigin];
}

- (IBAction)addAllowedStampFormat:(id)sender {
    if (self.allowedStampFormatToAdd == nil) return;
    
    [self.allowedStampFormatsController addObject:self.allowedStampFormatToAdd];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeAllowedStampFormat:(id)sender {
    [self.allowedStampFormatsController remove:self];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)save:(id)sender {
    // Save info into the associated default AlternateCatalog row.
    GPCatalog * defaultEntry = self.gpCatalogDefaultsController.content;
    
    AlternateCatalog * defaultAltCatalog;
    for (AlternateCatalog * ac in defaultEntry.alternateCatalogs) {
        defaultAltCatalog = ac;
        break;
    }
    
    defaultAltCatalog.alternateCatalogName = defaultEntry.defaultCatalogName;
    defaultAltCatalog.alternateCatalogGroup = self.selectedAltCatalogSection;
    
    [self.document saveInPlace];
    
    [self.window performClose:self];
}

- (IBAction)clear:(id)sender {
    GPCatalog * defaults = self.gpCatalogDefaultsController.content;
    [self.managedObjectContext deleteObject:defaults];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
    }
    
    GPCatalog * entry = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalog" inManagedObjectContext:self.managedObjectContext];
    entry.is_default = [NSNumber numberWithBool:YES];
    
    // Create a row in the AlternateCatalogs table associated with the default.
    // The catalog number for the row is NOT specified.
    AlternateCatalog * altCatalog = [NSEntityDescription insertNewObjectForEntityForName:@"AlternateCatalog" inManagedObjectContext:self.managedObjectContext];
    [entry addAlternateCatalogsObject:altCatalog];
    
    [self.gpCatalogDefaultsController setContent:entry];
    
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
}

- (IBAction)addGPCatalogDate:(id)sender {
    [self.gpCatalogDateController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogDate:(id)sender {
    [self.gpCatalogDateController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogPerson:(id)sender {
    [self.gpCatalogPeopleController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPPlateSize:(id)sender {
    [self.gpPlateSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPPlateSize:(id)sender {
    [self.gpPlateSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogQuantity:(id)sender {
    [self.gpCatalogQuantityController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)addGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController add:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)removeGPCatalogAlbumSize:(id)sender {
    [self.gpCatalogAlbumSizeController remove:sender];
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

- (IBAction)createAlbumSizesFromAvailableFormats:(id)sender {
    GPCatalog * entry = self.gpCatalogDefaultsController.content;
    NSSet * availableFormats = [entry allowedStampFormats];
    
    for (StampFormat * format in availableFormats) {
        GPCatalogAlbumSize * albumSize = [NSEntityDescription insertNewObjectForEntityForName:@"GPCatalogAlbumSize" inManagedObjectContext:self.managedObjectContext];
        albumSize.format = format;
        
        [entry addAlbumSizesObject:albumSize];
    }
    
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext undo];
        return;
    }
}

@end
