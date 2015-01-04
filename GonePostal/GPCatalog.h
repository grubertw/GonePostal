//
//  GPCatalog.h
//  GonePostal
//
//  Created by Travis Gruber on 1/3/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalog, AlternateCatalogName, Attachment, BureauPrecancel, Cachet, Cancelations, Country, Format, GPCatalog, GPCatalogAlbumSize, GPCatalogDate, GPCatalogGroup, GPCatalogPeople, GPCatalogQuantity, GPCatalogSet, GPPicture, GPPlateSize, GPSalesGroup, GPSubvarietyType, LooksLike, NumberOfStampsInPlate, PlateNumber, PlateUsage, Stamp, StampFormat, Topic, Valuation;

@interface GPCatalog : NSManagedObject

@property (nonatomic, retain) NSNumber * album_height;
@property (nonatomic, retain) NSNumber * album_width;
@property (nonatomic, retain) NSString * alternate_picture_1;
@property (nonatomic, retain) NSString * alternate_picture_2;
@property (nonatomic, retain) NSString * alternate_picture_3;
@property (nonatomic, retain) NSString * alternate_picture_4;
@property (nonatomic, retain) NSString * alternate_picture_5;
@property (nonatomic, retain) NSString * alternate_picture_6;
@property (nonatomic, retain) NSNumber * always_display;
@property (nonatomic, retain) NSString * background_information;
@property (nonatomic, retain) NSString * color;
@property (nonatomic, retain) NSNumber * color_error;
@property (nonatomic, retain) NSNumber * color_variety;
@property (nonatomic, retain) NSNumber * composite_placeholder;
@property (nonatomic, retain) NSDate * date_documented_first_use;
@property (nonatomic, retain) NSNumber * date_documented_first_use_exact;
@property (nonatomic, retain) NSDate * date_issued;
@property (nonatomic, retain) NSNumber * date_issued_exact;
@property (nonatomic, retain) NSString * default_picture;
@property (nonatomic, retain) NSString * denomination;
@property (nonatomic, retain) NSString * design_measurement;
@property (nonatomic, retain) NSString * designers;
@property (nonatomic, retain) NSString * engravers;
@property (nonatomic, retain) NSString * envelope_size;
@property (nonatomic, retain) NSNumber * foldable;
@property (nonatomic, retain) NSString * gp_catalog_number;
@property (nonatomic, retain) NSString * gp_description;
@property (nonatomic, retain) NSString * gum;
@property (nonatomic, retain) NSNumber * gum_variety;
@property (nonatomic, retain) NSNumber * has_subvarieties;
@property (nonatomic, retain) NSNumber * hidden;
@property (nonatomic, retain) NSString * identification_notes;
@property (nonatomic, retain) NSNumber * is_custom;
@property (nonatomic, retain) NSNumber * is_default;
@property (nonatomic, retain) NSString * issue_location;
@property (nonatomic, retain) NSString * issue_name;
@property (nonatomic, retain) NSString * knife;
@property (nonatomic, retain) NSString * long_description;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) NSNumber * multiple_transfer;
@property (nonatomic, retain) NSNumber * number_of_panes;
@property (nonatomic, retain) NSNumber * number_of_plates;
@property (nonatomic, retain) NSNumber * number_of_plates_used;
@property (nonatomic, retain) NSNumber * other_error;
@property (nonatomic, retain) NSNumber * packaging;
@property (nonatomic, retain) NSNumber * pane_size;
@property (nonatomic, retain) NSString * paper_color;
@property (nonatomic, retain) NSString * paper_type;
@property (nonatomic, retain) NSNumber * perf_error;
@property (nonatomic, retain) NSString * perforation;
@property (nonatomic, retain) NSString * perforation_type;
@property (nonatomic, retain) NSNumber * plate_block_quantity;
@property (nonatomic, retain) NSNumber * plate_error;
@property (nonatomic, retain) NSNumber * plate_size;
@property (nonatomic, retain) NSNumber * plate_variation;
@property (nonatomic, retain) NSString * plate_variation_type;
@property (nonatomic, retain) NSNumber * plated;
@property (nonatomic, retain) NSString * press;
@property (nonatomic, retain) NSString * print;
@property (nonatomic, retain) NSNumber * print_variety;
@property (nonatomic, retain) NSString * printer;
@property (nonatomic, retain) NSNumber * printing_on_back;
@property (nonatomic, retain) NSNumber * quantity_ordered;
@property (nonatomic, retain) NSNumber * quantity_printed;
@property (nonatomic, retain) NSNumber * quantity_sold;
@property (nonatomic, retain) NSString * revenue_paper_imprint_location;
@property (nonatomic, retain) NSString * revenue_paper_individule_account;
@property (nonatomic, retain) NSString * revenue_paper_issuing_agency;
@property (nonatomic, retain) NSString * revenue_paper_printer;
@property (nonatomic, retain) NSString * revenue_paper_type;
@property (nonatomic, retain) NSString * series;
@property (nonatomic, retain) NSString * surcharge_color;
@property (nonatomic, retain) NSString * surcharge_notes;
@property (nonatomic, retain) NSString * surcharge_print;
@property (nonatomic, retain) NSString * surcharge_printer;
@property (nonatomic, retain) NSString * surcharge_text;
@property (nonatomic, retain) NSString * surcharge_type;
@property (nonatomic, retain) NSNumber * surcharged;
@property (nonatomic, retain) NSString * tag;
@property (nonatomic, retain) NSNumber * tag_error;
@property (nonatomic, retain) NSNumber * tag_variety;
@property (nonatomic, retain) NSString * variety_description;
@property (nonatomic, retain) NSNumber * variety_type;
@property (nonatomic, retain) NSNumber * very_rare;
@property (nonatomic, retain) NSString * watermark;
@property (nonatomic, retain) NSNumber * watermark_error;
@property (nonatomic, retain) NSNumber * watermark_variation;
@property (nonatomic, retain) NSSet *albumSizes;
@property (nonatomic, retain) NSSet *allowedStampFormats;
@property (nonatomic, retain) NSSet *alternateCatalogs;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *bureauPrecancels;
@property (nonatomic, retain) NSSet *cachets;
@property (nonatomic, retain) NSSet *cancelations;
@property (nonatomic, retain) GPCatalogGroup *catalogGroup;
@property (nonatomic, retain) NSSet *catalogSets;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) NSSet *dates;
@property (nonatomic, retain) AlternateCatalogName *defaultCatalogName;
@property (nonatomic, retain) NSSet *examples;
@property (nonatomic, retain) NSSet *extraPictures;
@property (nonatomic, retain) Format *formatType;
@property (nonatomic, retain) NSSet *looksLike;
@property (nonatomic, retain) GPCatalog *majorVariety;
@property (nonatomic, retain) NSSet *numberOfStampsInPlate;
@property (nonatomic, retain) NSSet *people;
@property (nonatomic, retain) NSSet *plateNumbers;
@property (nonatomic, retain) NSSet *plateSizes;
@property (nonatomic, retain) NSSet *plateUsage;
@property (nonatomic, retain) NSSet *quantities;
@property (nonatomic, retain) GPSalesGroup *salesGroup;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *subvarieties;
@property (nonatomic, retain) GPSubvarietyType *subvarietyType;
@property (nonatomic, retain) NSSet *topics;
@property (nonatomic, retain) NSSet *values;
@end

@interface GPCatalog (CoreDataGeneratedAccessors)

- (void)addAlbumSizesObject:(GPCatalogAlbumSize *)value;
- (void)removeAlbumSizesObject:(GPCatalogAlbumSize *)value;
- (void)addAlbumSizes:(NSSet *)values;
- (void)removeAlbumSizes:(NSSet *)values;

- (void)addAllowedStampFormatsObject:(StampFormat *)value;
- (void)removeAllowedStampFormatsObject:(StampFormat *)value;
- (void)addAllowedStampFormats:(NSSet *)values;
- (void)removeAllowedStampFormats:(NSSet *)values;

- (void)addAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)removeAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)addAlternateCatalogs:(NSSet *)values;
- (void)removeAlternateCatalogs:(NSSet *)values;

- (void)addAttachmentsObject:(Attachment *)value;
- (void)removeAttachmentsObject:(Attachment *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

- (void)addBureauPrecancelsObject:(BureauPrecancel *)value;
- (void)removeBureauPrecancelsObject:(BureauPrecancel *)value;
- (void)addBureauPrecancels:(NSSet *)values;
- (void)removeBureauPrecancels:(NSSet *)values;

- (void)addCachetsObject:(Cachet *)value;
- (void)removeCachetsObject:(Cachet *)value;
- (void)addCachets:(NSSet *)values;
- (void)removeCachets:(NSSet *)values;

- (void)addCancelationsObject:(Cancelations *)value;
- (void)removeCancelationsObject:(Cancelations *)value;
- (void)addCancelations:(NSSet *)values;
- (void)removeCancelations:(NSSet *)values;

- (void)addCatalogSetsObject:(GPCatalogSet *)value;
- (void)removeCatalogSetsObject:(GPCatalogSet *)value;
- (void)addCatalogSets:(NSSet *)values;
- (void)removeCatalogSets:(NSSet *)values;

- (void)addDatesObject:(GPCatalogDate *)value;
- (void)removeDatesObject:(GPCatalogDate *)value;
- (void)addDates:(NSSet *)values;
- (void)removeDates:(NSSet *)values;

- (void)addExamplesObject:(Stamp *)value;
- (void)removeExamplesObject:(Stamp *)value;
- (void)addExamples:(NSSet *)values;
- (void)removeExamples:(NSSet *)values;

- (void)addExtraPicturesObject:(GPPicture *)value;
- (void)removeExtraPicturesObject:(GPPicture *)value;
- (void)addExtraPictures:(NSSet *)values;
- (void)removeExtraPictures:(NSSet *)values;

- (void)addLooksLikeObject:(LooksLike *)value;
- (void)removeLooksLikeObject:(LooksLike *)value;
- (void)addLooksLike:(NSSet *)values;
- (void)removeLooksLike:(NSSet *)values;

- (void)addNumberOfStampsInPlateObject:(NumberOfStampsInPlate *)value;
- (void)removeNumberOfStampsInPlateObject:(NumberOfStampsInPlate *)value;
- (void)addNumberOfStampsInPlate:(NSSet *)values;
- (void)removeNumberOfStampsInPlate:(NSSet *)values;

- (void)addPeopleObject:(GPCatalogPeople *)value;
- (void)removePeopleObject:(GPCatalogPeople *)value;
- (void)addPeople:(NSSet *)values;
- (void)removePeople:(NSSet *)values;

- (void)addPlateNumbersObject:(PlateNumber *)value;
- (void)removePlateNumbersObject:(PlateNumber *)value;
- (void)addPlateNumbers:(NSSet *)values;
- (void)removePlateNumbers:(NSSet *)values;

- (void)addPlateSizesObject:(GPPlateSize *)value;
- (void)removePlateSizesObject:(GPPlateSize *)value;
- (void)addPlateSizes:(NSSet *)values;
- (void)removePlateSizes:(NSSet *)values;

- (void)addPlateUsageObject:(PlateUsage *)value;
- (void)removePlateUsageObject:(PlateUsage *)value;
- (void)addPlateUsage:(NSSet *)values;
- (void)removePlateUsage:(NSSet *)values;

- (void)addQuantitiesObject:(GPCatalogQuantity *)value;
- (void)removeQuantitiesObject:(GPCatalogQuantity *)value;
- (void)addQuantities:(NSSet *)values;
- (void)removeQuantities:(NSSet *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addSubvarietiesObject:(GPCatalog *)value;
- (void)removeSubvarietiesObject:(GPCatalog *)value;
- (void)addSubvarieties:(NSSet *)values;
- (void)removeSubvarieties:(NSSet *)values;

- (void)addTopicsObject:(Topic *)value;
- (void)removeTopicsObject:(Topic *)value;
- (void)addTopics:(NSSet *)values;
- (void)removeTopics:(NSSet *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
