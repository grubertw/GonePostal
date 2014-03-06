//
//  SaleHistory.h
//  GonePostal
//
//  Created by Travis Gruber on 3/5/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp;

@interface SaleHistory : NSManagedObject

@property (nonatomic, retain) NSNumber * askingPrice;
@property (nonatomic, retain) NSString * auctionNumber;
@property (nonatomic, retain) NSDate * dateSold;
@property (nonatomic, retain) NSString * lotNumber;
@property (nonatomic, retain) NSString * saleDescription;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSString * soldBy;
@property (nonatomic, retain) NSNumber * isDefault;
@property (nonatomic, retain) Stamp *stamp;

@end
