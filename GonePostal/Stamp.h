//
//  Stamp.h
//  GonePostal
//
//  Created by Travis Gruber on 4/28/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BureauPrecancel, Cachet, CancelQuality, Centering, Dealer, GPCatalog, GPCollection, GPPicture, Grade, GumCondition, Hinged, LocalPrecancel, Location, Lot, Mount, Perfin, SaleHistory, Soundness, Stamp, StampFormat, Valuation;

@interface Stamp : NSManagedObject

@property (nonatomic, retain) NSString * address_type;
@property (nonatomic, retain) NSString * alternate_picture_1;
@property (nonatomic, retain) NSString * alternate_picture_2;
@property (nonatomic, retain) NSString * alternate_picture_3;
@property (nonatomic, retain) NSString * alternate_picture_4;
@property (nonatomic, retain) NSString * alternate_picture_5;
@property (nonatomic, retain) NSString * alternate_picture_6;
@property (nonatomic, retain) NSDate * cancelation_date;
@property (nonatomic, retain) NSString * cancelation_type;
@property (nonatomic, retain) NSString * census_id;
@property (nonatomic, retain) NSString * certificates;
@property (nonatomic, retain) NSString * default_picture;
@property (nonatomic, retain) NSString * faults;
@property (nonatomic, retain) NSString * gp_stamp_number;
@property (nonatomic, retain) NSString * history;
@property (nonatomic, retain) NSString * inprint_1;
@property (nonatomic, retain) NSString * inprint_2;
@property (nonatomic, retain) NSNumber * inventory_number;
@property (nonatomic, retain) NSNumber * last_sale_price;
@property (nonatomic, retain) NSNumber * manual_value;
@property (nonatomic, retain) NSNumber * mint_used;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * plate_1;
@property (nonatomic, retain) NSString * plate_2;
@property (nonatomic, retain) NSString * plate_3;
@property (nonatomic, retain) NSString * plate_4;
@property (nonatomic, retain) NSString * plate_5;
@property (nonatomic, retain) NSString * plate_6;
@property (nonatomic, retain) NSString * plate_7;
@property (nonatomic, retain) NSString * plate_8;
@property (nonatomic, retain) NSString * plate_location;
@property (nonatomic, retain) NSString * plate_position;
@property (nonatomic, retain) NSNumber * purchase_amount;
@property (nonatomic, retain) NSDate * purchase_date;
@property (nonatomic, retain) NSString * source;
@property (nonatomic, retain) NSNumber * parentType;
@property (nonatomic, retain) BureauPrecancel *bureauPrecancel;
@property (nonatomic, retain) Cachet *cachet;
@property (nonatomic, retain) CancelQuality *cancelQuality;
@property (nonatomic, retain) Centering *centering;
@property (nonatomic, retain) NSSet *children;
@property (nonatomic, retain) GPCollection *collection;
@property (nonatomic, retain) Dealer *dealer;
@property (nonatomic, retain) NSSet *extraPictures;
@property (nonatomic, retain) StampFormat *format;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) Grade *grade;
@property (nonatomic, retain) GumCondition *gumCondition;
@property (nonatomic, retain) Hinged *hinged;
@property (nonatomic, retain) LocalPrecancel *localPrecancel;
@property (nonatomic, retain) Location *location;
@property (nonatomic, retain) Lot *lot;
@property (nonatomic, retain) Mount *mount;
@property (nonatomic, retain) Stamp *parent;
@property (nonatomic, retain) Perfin *perfin;
@property (nonatomic, retain) NSSet *saleHistory;
@property (nonatomic, retain) Soundness *soundness;
@property (nonatomic, retain) Valuation *valuation;
@end

@interface Stamp (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Stamp *)value;
- (void)removeChildrenObject:(Stamp *)value;
- (void)addChildren:(NSSet *)values;
- (void)removeChildren:(NSSet *)values;

- (void)addExtraPicturesObject:(GPPicture *)value;
- (void)removeExtraPicturesObject:(GPPicture *)value;
- (void)addExtraPictures:(NSSet *)values;
- (void)removeExtraPictures:(NSSet *)values;

- (void)addSaleHistoryObject:(SaleHistory *)value;
- (void)removeSaleHistoryObject:(SaleHistory *)value;
- (void)addSaleHistory:(NSSet *)values;
- (void)removeSaleHistory:(NSSet *)values;

@end
