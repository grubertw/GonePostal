//
//  GPStampDefaults.m
//  GonePostal
//
//  Created by Travis Gruber on 7/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPStampDefaults.h"
#import "GonePostal-Swift.h"

@interface GPStampDefaults ()
@property (strong, nonatomic) GPDocument * doc;

@end

@implementation GPStampDefaults

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialize the sort descriptors
        NSSortDescriptor *formatSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _formatSortDescriptors = @[formatSort];
        
        NSSortDescriptor *centeringSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _centeringSortDescriptors = @[centeringSort];
        
        NSSortDescriptor *soundnessSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _soundnessSortDescriptors = @[soundnessSort];
        
        NSSortDescriptor *gradeSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _gradeSortDescriptors = @[gradeSort];
        
        NSSortDescriptor *cancelQualitySort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _cancelQualitySortDescriptors = @[cancelQualitySort];
        
        NSSortDescriptor *gumcondSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _gumConditionSortDescriptors = @[gumcondSort];
        
        NSSortDescriptor *hingedSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _hingedSortDescriptors = @[hingedSort];
        
        NSSortDescriptor *dealerSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _dealerSortDescriptors = @[dealerSort];
        
        NSSortDescriptor *lotSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _lotSortDescriptors = @[lotSort];
        
        NSSortDescriptor *locationSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _locationSortDescriptors = @[locationSort];
        
        NSSortDescriptor *mountSort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
        _mountSortDescriptors = @[mountSort];
        
        NSDocumentController * docController = [NSDocumentController sharedDocumentController];
        _doc = [docController currentDocument];
        _managedObjectContext = _doc.managedObjectContext;
        
        // Create the defaults if they do not exist.
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"Stamp"];
        NSPredicate *query = [NSPredicate predicateWithFormat:@"is_default == YES"];
        [fetch setPredicate:query];
        
        // Execute the query
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        if (results && [results count] == 1) {
            _stamp = results[0];
        }
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
}

- (IBAction)done:(id)sender {
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window completionHandler:nil];
        [self.managedObjectContext rollback];
    }
    
    [self.window close];
}

@end
