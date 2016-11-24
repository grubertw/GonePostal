//
//  Stamp+CoreDataProperties.h
//  GonePostal
//
//  Created by Travis Gruber on 11/20/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

#import "Stamp.h"


NS_ASSUME_NONNULL_BEGIN

@interface Stamp (CoreDataProperties)

+ (NSFetchRequest<Stamp *> *)fetchRequest;

@property (nullable, nonatomic, copy) NSString *address_type;
@property (nullable, nonatomic, copy) NSString *alternate_picture_1;
@property (nullable, nonatomic, copy) NSString *alternate_picture_2;
@property (nullable, nonatomic, copy) NSString *alternate_picture_3;
@property (nullable, nonatomic, copy) NSString *alternate_picture_4;
@property (nullable, nonatomic, copy) NSString *alternate_picture_5;
@property (nullable, nonatomic, copy) NSString *alternate_picture_6;
@property (nullable, nonatomic, copy) NSNumber *blockHasPlateNumber;
@property (nullable, nonatomic, copy) NSNumber *blockSelvageBottom;
@property (nullable, nonatomic, copy) NSNumber *blockSelvageLeft;
@property (nullable, nonatomic, copy) NSNumber *blockSelvageRight;
@property (nullable, nonatomic, copy) NSNumber *blockSelvageTop;
@property (nullable, nonatomic, copy) NSDate *cancelation_date;
@property (nullable, nonatomic, copy) NSString *cancelation_type;
@property (nullable, nonatomic, copy) NSNumber *catalog_value;
@property (nullable, nonatomic, copy) NSString *census_id;
@property (nullable, nonatomic, copy) NSString *certificates;
@property (nullable, nonatomic, copy) NSString *composite_description;
@property (nullable, nonatomic, copy) NSString *composite_name;
@property (nullable, nonatomic, copy) NSString *default_picture;
@property (nullable, nonatomic, copy) NSString *faults;
@property (nullable, nonatomic, copy) NSNumber *folded;
@property (nullable, nonatomic, copy) NSString *gp_stamp_number;
@property (nullable, nonatomic, copy) NSString *history;
@property (nullable, nonatomic, copy) NSString *inprint_1;
@property (nullable, nonatomic, copy) NSString *inprint_2;
@property (nullable, nonatomic, copy) NSNumber *inventory_number;
@property (nullable, nonatomic, copy) NSNumber *irregularBlock;
@property (nullable, nonatomic, copy) NSNumber *is_default;
@property (nullable, nonatomic, copy) NSNumber *last_sale_price;
@property (nullable, nonatomic, copy) NSNumber *manual_value;
@property (nullable, nonatomic, copy) NSNumber *manual_value_overrides_catalog_value;
@property (nullable, nonatomic, copy) NSString *marking;
@property (nullable, nonatomic, copy) NSNumber *mint_used;
@property (nullable, nonatomic, copy) NSNumber *modifiedByUser;
@property (nullable, nonatomic, copy) NSString *notes;
@property (nullable, nonatomic, copy) NSNumber *numStampsInBlock;
@property (nullable, nonatomic, copy) NSNumber *numStampsInBlockHorrizontal;
@property (nullable, nonatomic, copy) NSNumber *numStampsInBlockVertical;
@property (nullable, nonatomic, copy) NSNumber *origionalPackaging;
@property (nullable, nonatomic, copy) NSNumber *parentType;
@property (nullable, nonatomic, copy) NSString *plate_1;
@property (nullable, nonatomic, copy) NSString *plate_2;
@property (nullable, nonatomic, copy) NSString *plate_3;
@property (nullable, nonatomic, copy) NSString *plate_4;
@property (nullable, nonatomic, copy) NSString *plate_5;
@property (nullable, nonatomic, copy) NSString *plate_6;
@property (nullable, nonatomic, copy) NSString *plate_7;
@property (nullable, nonatomic, copy) NSString *plate_8;
@property (nullable, nonatomic, copy) NSString *plate_location;
@property (nullable, nonatomic, copy) NSString *plate_position;
@property (nullable, nonatomic, copy) NSNumber *purchase_amount;
@property (nullable, nonatomic, copy) NSDate *purchase_date;
@property (nullable, nonatomic, copy) NSString *serial_number;
@property (nullable, nonatomic, copy) NSString *source;
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
@property (nullable, nonatomic, retain) PlateNumber *plateNumber;
@property (nullable, nonatomic, retain) NSSet<SaleHistory *> *saleHistory;
@property (nullable, nonatomic, retain) Soundness *soundness;
@property (nullable, nonatomic, retain) GPCatalogSet *gpCatalogSet;

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
