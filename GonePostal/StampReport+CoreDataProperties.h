//
//  StampReport+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 5/30/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "StampReport.h"

NS_ASSUME_NONNULL_BEGIN

@interface StampReport (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gp_stamp_number;
@property (nullable, nonatomic, retain) NSString *catalogNameAndNumber;
@property (nullable, nonatomic, retain) NSString *stampDescription;
@property (nullable, nonatomic, retain) NSNumber *inventory_number;
@property (nullable, nonatomic, retain) NSString *countryAndSection;
@property (nullable, nonatomic, retain) NSString *condition;
@property (nullable, nonatomic, retain) NSString *additionalInfo;
@property (nullable, nonatomic, retain) NSDate *reportCreationTime;
@property (nullable, nonatomic, retain) Country *country;
@property (nullable, nonatomic, retain) GPCatalogGroup *section;
@property (nullable, nonatomic, retain) StampFormat *format;
@property (nullable, nonatomic, retain) Location *location;

@end

NS_ASSUME_NONNULL_END
