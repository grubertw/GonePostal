//
//  SaleHistory+Create.h
//  GonePostal
//
//  Created by Travis Gruber on 3/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import "SaleHistory.h"

@interface SaleHistory (Create)

+ (SaleHistory *)createFromDefaultUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
