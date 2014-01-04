//
//  Valuation.h
//  GonePostal
//
//  Created by Travis Gruber on 8/19/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class BureauPrecancel, Cachet, CancelQuality, Centering, GPCatalog, Grade, GumCondition, Hinged, PlateNumber, PriceList, Soundness, StampFormat;

@interface Valuation : NSManagedObject

@property (nonatomic, retain) NSNumber * price;
@property (nonatomic, retain) NSNumber * decisionLevel;
@property (nonatomic, retain) BureauPrecancel *bureauPrecancel;
@property (nonatomic, retain) Cachet *cachet;
@property (nonatomic, retain) CancelQuality *cancelQuality;
@property (nonatomic, retain) Centering *centering;
@property (nonatomic, retain) GPCatalog *gpCatalog;
@property (nonatomic, retain) Grade *grade;
@property (nonatomic, retain) GumCondition *gumCondition;
@property (nonatomic, retain) Hinged *hinged;
@property (nonatomic, retain) PlateNumber *plateNumberCombo;
@property (nonatomic, retain) Soundness *soundness;
@property (nonatomic, retain) StampFormat *stampFormat;
@property (nonatomic, retain) PriceList *priceList;

@end
