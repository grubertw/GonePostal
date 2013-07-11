//
//  Stamp+Create.h
//  GonePostal
//
//  Created by Travis Gruber on 7/6/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "Stamp.h"

@interface Stamp (Create)

+ (Stamp *)CreateFromDefaultsUsingManagedObjectContext:(NSManagedObjectContext *)managedObjectContext;

- (void)setToDefaults;

@end
