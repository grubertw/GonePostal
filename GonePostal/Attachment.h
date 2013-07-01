//
//  Attachment.h
//  GonePostal
//
//  Created by Travis Gruber on 6/29/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Country, GPCatalog, GPSalesGroup, Subject;

@interface Attachment : NSManagedObject

@property (nonatomic, retain) NSString * attachmentDescription;
@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * author;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSDate * datePublished;
@property (nonatomic, retain) NSString * publishedBy;
@property (nonatomic, retain) NSString * magazineName;
@property (nonatomic, retain) NSString * magazineIssue;
@property (nonatomic, retain) NSString * gp_attachment_number;
@property (nonatomic, retain) GPCatalog *gpCatalogEntry;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) Subject *subject;
@property (nonatomic, retain) GPSalesGroup *salesGroup;

@end
