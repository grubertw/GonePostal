//
//  SaleHistory.h
//  GonePostal
//
//  Created by Travis Gruber on 4/20/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Stamp;

@interface SaleHistory : NSManagedObject

@property (nonatomic, retain) NSDate * dateSold;
@property (nonatomic, retain) NSString * soldBy;
@property (nonatomic, retain) NSNumber * askingPrice;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSString * saleDescription;
@property (nonatomic, retain) NSString * lotNumber;
@property (nonatomic, retain) NSString * auctionNumber;
@property (nonatomic, retain) Stamp *stamp;

@end
