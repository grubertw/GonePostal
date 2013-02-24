//
//  FDCIssueLocation.h
//  GonePostalX
//
//  Created by Travis Gruber on 1/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class GPCatalog;

@interface FDCIssueLocation : NSManagedObject

@property (nonatomic, retain) NSDate * fdc_issue_location_date;
@property (nonatomic, retain) NSString * fdc_issue_location_name;
@property (nonatomic, retain) GPCatalog *gpCatalog;

@end
