//
//  Stamp+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 5/22/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Stamp.h"

NS_ASSUME_NONNULL_BEGIN

@interface Stamp (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *address_type;
@property (nullable, nonatomic, retain) NSString *alternate_picture_1;
@property (nullable, nonatomic, retain) NSString *alternate_picture_2;
@property (nullable, nonatomic, retain) NSString *alternate_picture_3;
@property (nullable, nonatomic, retain) NSString *alternate_picture_4;
@property (nullable, nonatomic, retain) NSString *alternate_picture_5;
@property (nullable, nonatomic, retain) NSString *alternate_picture_6;
@property (nullable, nonatomic, retain) NSNumber *blockHasPlateNumber;
@property (nullable, nonatomic, retain) NSNumber *blockSelvageBottom;
@property (nullable, nonatomic, retain) NSNumber *blockSelvageLeft;
@property (nullable, nonatomic, retain) NSNumber *blockSelvageRight;
@property (nullable, nonatomic, retain) NSNumber *blockSelvageTop;
@property (nullable, nonatomic, retain) NSDate *cancelation_date;
@property (nullable, nonatomic, retain) NSString *cancelation_type;
@property (nullable, nonatomic, retain) NSNumber *catalog_value;
@property (nullable, nonatomic, retain) NSString *census_id;
@property (nullable, nonatomic, retain) NSString *certificates;
@property (nullable, nonatomic, retain) NSString *composite_description;
@property (nullable, nonatomic, retain) NSString *composite_name;
@property (nullable, nonatomic, retain) NSString *default_picture;
@property (nullable, nonatomic, retain) NSString *faults;
@property (nullable, nonatomic, retain) NSNumber *folded;
@property (nullable, nonatomic, retain) NSString *gp_stamp_number;
@property (nullable, nonatomic, retain) NSString *history;
@property (nullable, nonatomic, retain) NSString *inprint_1;
@property (nullable, nonatomic, retain) NSString *inprint_2;
@property (nullable, nonatomic, retain) NSNumber *inventory_number;
@property (nullable, nonatomic, retain) NSNumber *irregularBlock;
@property (nullable, nonatomic, retain) NSNumber *is_default;
@property (nullable, nonatomic, retain) NSNumber *last_sale_price;
@property (nullable, nonatomic, retain) NSNumber *manual_value;
@property (nullable, nonatomic, retain) NSNumber *manual_value_overrides_catalog_value;
@property (nullable, nonatomic, retain) NSNumber *mint_used;
@property (nullable, nonatomic, retain) NSNumber *modifiedByUser;
@property (nullable, nonatomic, retain) NSString *notes;
@property (nullable, nonatomic, retain) NSNumber *numStampsInBlock;
@property (nullable, nonatomic, retain) NSNumber *numStampsInBlockHorrizontal;
@property (nullable, nonatomic, retain) NSNumber *numStampsInBlockVertical;
@property (nullable, nonatomic, retain) NSNumber *origionalPackaging;
@property (nullable, nonatomic, retain) NSNumber *parentType;
@property (nullable, nonatomic, retain) NSString *plate_1;
@property (nullable, nonatomic, retain) NSString *plate_2;
@property (nullable, nonatomic, retain) NSString *plate_3;
@property (nullable, nonatomic, retain) NSString *plate_4;
@property (nullable, nonatomic, retain) NSString *plate_5;
@property (nullable, nonatomic, retain) NSString *plate_6;
@property (nullable, nonatomic, retain) NSString *plate_7;
@property (nullable, nonatomic, retain) NSString *plate_8;
@property (nullable, nonatomic, retain) NSString *plate_location;
@property (nullable, nonatomic, retain) NSString *plate_position;
@property (nullable, nonatomic, retain) NSNumber *purchase_amount;
@property (nullable, nonatomic, retain) NSDate *purchase_date;
@property (nullable, nonatomic, retain) NSString *serial_number;
@property (nullable, nonatomic, retain) NSString *source;
@property (nullable, nonatomic, retain) NSString *marking;
@property (nullable, nonatomic, retain) BureauPrecancel *bureauPrecancel;
@property (nullable, nonatomic, retain) Cachet *cachet;
@property (nullable, nonatomic, retain) CancelQuality *cancelQuality;
@property (nullable, nonatomic, retain) Centering *centering;
@property (nullable, nonatomic, retain) NSSet<Stamp *> *children;
@property (nullable, nonatomic, retain) NSSet<GPCollection *> *collections;
@property (nullable, nonatomic, retain) Dealer *dealer;
@property (nullable, nonatomic, retain) GPCatalog *example;
@property (nullable, nonatomic, retain) NSSet<GPPicture *> *extraPictures;
@property (nullable, nonatomic, retain) StampFormat *format;
@property (nullable, nonatomic, retain) GPCatalog *gpCatalog;
@property (nullable, nonatomic, retain) Grade *grade;
@property (nullable, nonatomic, retain) GumCondition *gumCondition;
@property (nullable, nonatomic, retain) Hinged *hinged;
@property (nullable, nonatomic, retain) LocalPrecancel *localPrecancel;
@property (nullable, nonatomic, retain) Location *location;
@property (nullable, nonatomic, retain) Lot *lot;
@property (nullable, nonatomic, retain) Mount *mount;
@property (nullable, nonatomic, retain) Stamp *parent;
@property (nullable, nonatomic, retain) Perfin *perfin;
@property (nullable, nonatomic, retain) NSSet<SaleHistory *> *saleHistory;
@property (nullable, nonatomic, retain) Soundness *soundness;
@property (nullable, nonatomic, retain) PlateNumber *plateNumber;

@end

@interface Stamp (CoreDataGeneratedAccessors)

- (void)addChildrenObject:(Stamp *)value;
- (void)removeChildrenObject:(Stamp *)value;
- (void)addChildren:(NSSet<Stamp *> *)values;
- (void)removeChildren:(NSSet<Stamp *> *)values;

- (void)addCollectionsObject:(GPCollection *)value;
- (void)removeCollectionsObject:(GPCollection *)value;
- (void)addCollections:(NSSet<GPCollection *> *)values;
- (void)removeCollections:(NSSet<GPCollection *> *)values;

- (void)addExtraPicturesObject:(GPPicture *)value;
- (void)removeExtraPicturesObject:(GPPicture *)value;
- (void)addExtraPictures:(NSSet<GPPicture *> *)values;
- (void)removeExtraPictures:(NSSet<GPPicture *> *)values;

- (void)addSaleHistoryObject:(SaleHistory *)value;
- (void)removeSaleHistoryObject:(SaleHistory *)value;
- (void)addSaleHistory:(NSSet<SaleHistory *> *)values;
- (void)removeSaleHistory:(NSSet<SaleHistory *> *)values;

@end

NS_ASSUME_NONNULL_END
