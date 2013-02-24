//
//  GPAlternateCatalogNumberTransformer.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/9/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GPAlternateCatalogNumberTransformer : NSValueTransformer

@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

@end
