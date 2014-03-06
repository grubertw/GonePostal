//
//  GPSaleHistoryDefaults.m
//  GonePostal
//
//  Created by Travis Gruber on 3/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "GPSaleHistoryDefaults.h"
#import "GPDocument.h"

@interface GPSaleHistoryDefaults ()

@end

@implementation GPSaleHistoryDefaults

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        GPDocument * doc = [[NSDocumentController sharedDocumentController] currentDocument];
        _managedObjectContext = [doc managedObjectContext];
        
        // Create the defaults if they do not exist.
        NSFetchRequest *fetch = [NSFetchRequest fetchRequestWithEntityName:@"SaleHistory"];
        NSPredicate *query = [NSPredicate predicateWithFormat:@"isDefault == YES"];
        [fetch setPredicate:query];
        
        // Execute the query
        NSArray *results = [self.managedObjectContext executeFetchRequest:fetch error:nil];
        if (results && [results count] == 1) {
            _saleHistory = results[0];
        }
        else {
            _saleHistory = [NSEntityDescription insertNewObjectForEntityForName:@"SaleHistory" inManagedObjectContext:self.managedObjectContext];
            self.saleHistory.isDefault = @(YES);
        }
    }
    return self;
}

- (IBAction)done:(id)sender {
    NSError * error;
    if (![self.managedObjectContext save:&error]) {
        NSAlert * errSheet = [NSAlert alertWithError:error];
        [errSheet beginSheetModalForWindow:self.window modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [self.managedObjectContext rollback];
    }
    
    [self.window close];
}

@end
