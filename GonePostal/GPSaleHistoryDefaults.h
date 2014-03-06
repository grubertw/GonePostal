//
//  GPSaleHistoryDefaults.h
//  GonePostal
//
//  Created by Travis Gruber on 3/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SaleHistory.h"

@interface GPSaleHistoryDefaults : NSWindowController

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) SaleHistory * saleHistory;

@end
