//
//  SaleHistory+Create.m
//  GonePostal
//
//  Created by Travis Gruber on 3/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "SaleHistory+Create.h"

@implementation SaleHistory (Create)

+ (SaleHistory *)createFromDefaultUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext {
    SaleHistory * sh = [NSEntityDescription insertNewObjectForEntityForName:@"SaleHistory" inManagedObjectContext:managedObjectContext];
    
    // Get the default SaleHistory.
    NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"SaleHistory"];
    NSPredicate *query = [NSPredicate predicateWithFormat:@"isDefault == YES"];
    [fetchRequest setPredicate:query];
    
    // Execute the query
    NSError *error = nil;
    NSArray *results = [managedObjectContext executeFetchRequest:fetchRequest error:&error];
    
    if (results && [results count] == 1) {
        SaleHistory * dsh = results[0];
        
        sh.askingPrice = dsh.askingPrice;
        sh.auctionNumber = dsh.auctionNumber;
        sh.dateSold = dsh.dateSold;
        sh.lotNumber = dsh.lotNumber;
        sh.saleDescription = dsh.saleDescription;
        sh.salePrice = dsh.salePrice;
        sh.soldBy = dsh.soldBy;
    }
    
    return sh;
}

@end
