//
//  Stamp.h
//  GonePostalX
//
//  Created by Travis Gruber on 2/15/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CancelQuality, Centering, Dealer, FirstFlight, GPCatalog, GPCollection, Grade, GumCondition, Hinged, LocalPrecancel, Location, Lot, Mount, Perfin, Soundness, StampFormat, Valuation;

@interface Stamp : NSManagedObject

@property (nonatomic, retain) NSNumber * inventory_number;
@property (nonatomic, retain) NSString * plate_2;
@property (nonatomic, retain) NSNumber * mint_used;
@property (nonatomic, retain) NSString * plate_1;
@property (nonatomic, retain) NSString * plate_3;
@property (nonatomic, retain) NSString * plate_4;
@property (nonatomic, retain) NSString * plate_5;
@property (nonatomic, retain) NSString * plate_6;
@property (nonatomic, retain) NSString * plate_7;
@property (nonatomic, retain) NSString * plate_8;
@property (nonatomic, retain) NSString * inprint_1;
@property (nonatomic, retain) NSString * inprint_2;
@property (nonatomic, retain) NSString * cachet;
@property (nonatomic, retain) NSString * bureau_precancel;
@property (nonatomic, retain) NSDate * purchase_date;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSNumber * purchase_amount;
@property (nonatomic, retain) NSNumber * manual_value;
@property (nonatomic, retain) NSString * faults;
@property (nonatomic, retain) NSString * address_type;
@property (nonatomic, retain) NSString * cancelation_type;
@property (nonatomic, retain) NSDate * cancelation_date;
@property (nonatomic, retain) NSString * plate_location;
@property (nonatomic, retain) GPCollection *collection;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) Grade *grade;
@property (nonatomic, retain) Hinged *hinged;
@property (nonatomic, retain) GumCondition *gumCondition;
@property (nonatomic, retain) Soundness *soundness;
@property (nonatomic, retain) Centering *centering;
@property (nonatomic, retain) CancelQuality *cancelQuality;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Mount *mount;
@property (nonatomic, retain) Dealer *dealer;
@property (nonatomic, retain) Lot *lot;
@property (nonatomic, retain) Valuation *valuation;
@property (nonatomic, retain) LocalPrecancel *localPrecancel;
@property (nonatomic, retain) FirstFlight *firstFlight;
@property (nonatomic, retain) Perfin *perfin;
@property (nonatomic, retain) StampFormat *format;

@end
