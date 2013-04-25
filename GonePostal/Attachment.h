//
//  Attachment.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface Attachment : NSManagedObject

@property (nonatomic, retain) NSString * fileURL;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * attachmentDescription;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;

@end
