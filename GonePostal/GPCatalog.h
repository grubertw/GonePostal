//
//  GPCatalog.h
//  GonePostal
//
//  Created by Travis Gruber on 4/21/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class AlternateCatalog, AlternateCatalogName, Attachment, BureauPrecancel, Cachet, Cancelations, Country, Format, GPCatalog, GPCatalogGroup, GPCatalogSet, GPPicture, GPSubvarietyType, LooksLike, PlateNumber, PlateNumberInfo, PlateUsage, Stamp, Topic;

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
@property (nonatomic, retain) NSDate * date_documented_first_use;
@property (nonatomic, retain) NSNumber * date_documented_first_use_exact;
@property (nonatomic, retain) NSDate * date_issued;
@property (nonatomic, retain) NSNumber * date_issued_exact;
@property (nonatomic, retain) NSString * default_picture;
@property (nonatomic, retain) NSString * denomination;
@property (nonatomic, retain) NSString * design_measurement;
@property (nonatomic, retain) NSString * designers;
@property (nonatomic, retain) NSString * engravers;
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
@property (nonatomic, retain) NSString * long_description;
@property (nonatomic, retain) NSNumber * multiple_transfer;
@property (nonatomic, retain) NSNumber * number_of_panes;
@property (nonatomic, retain) NSNumber * number_of_plates;
@property (nonatomic, retain) NSNumber * number_of_plates_used;
@property (nonatomic, retain) NSNumber * other_error;
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
@property (nonatomic, retain) NSNumber * quantity_ordered;
@property (nonatomic, retain) NSNumber * quantity_printed;
@property (nonatomic, retain) NSNumber * quantity_sold;
@property (nonatomic, retain) NSString * series;
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
@property (nonatomic, retain) NSSet *alternateCatalogs;
@property (nonatomic, retain) NSSet *bureauPrecancels;
@property (nonatomic, retain) NSSet *cachets;
@property (nonatomic, retain) NSSet *cancelations;
@property (nonatomic, retain) GPCatalogGroup *catalogGroup;
@property (nonatomic, retain) NSSet *catalogSets;
@property (nonatomic, retain) Country *country;
@property (nonatomic, retain) AlternateCatalogName *defaultCatalogName;
@property (nonatomic, retain) NSSet *examples;
@property (nonatomic, retain) NSSet *extraPictures;
@property (nonatomic, retain) Format *formatType;
@property (nonatomic, retain) LooksLike *looksLike;
@property (nonatomic, retain) GPCatalog *majorVariety;
@property (nonatomic, retain) NSSet *plateNumberInfos;
@property (nonatomic, retain) NSSet *plateNumbers;
@property (nonatomic, retain) NSSet *plateUsage;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *subvarieties;
@property (nonatomic, retain) NSSet *topics;
@property (nonatomic, retain) GPSubvarietyType *subvarietyType;
@property (nonatomic, retain) NSSet *attachments;
@end

@interface GPCatalog (CoreDataGeneratedAccessors)

- (void)addAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)removeAlternateCatalogsObject:(AlternateCatalog *)value;
- (void)addAlternateCatalogs:(NSSet *)values;
- (void)removeAlternateCatalogs:(NSSet *)values;

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

- (void)addExamplesObject:(Stamp *)value;
- (void)removeExamplesObject:(Stamp *)value;
- (void)addExamples:(NSSet *)values;
- (void)removeExamples:(NSSet *)values;

- (void)addExtraPicturesObject:(GPPicture *)value;
- (void)removeExtraPicturesObject:(GPPicture *)value;
- (void)addExtraPictures:(NSSet *)values;
- (void)removeExtraPictures:(NSSet *)values;

- (void)addPlateNumberInfosObject:(PlateNumberInfo *)value;
- (void)removePlateNumberInfosObject:(PlateNumberInfo *)value;
- (void)addPlateNumberInfos:(NSSet *)values;
- (void)removePlateNumberInfos:(NSSet *)values;

- (void)addPlateNumbersObject:(PlateNumber *)value;
- (void)removePlateNumbersObject:(PlateNumber *)value;
- (void)addPlateNumbers:(NSSet *)values;
- (void)removePlateNumbers:(NSSet *)values;

- (void)addPlateUsageObject:(PlateUsage *)value;
- (void)removePlateUsageObject:(PlateUsage *)value;
- (void)addPlateUsage:(NSSet *)values;
- (void)removePlateUsage:(NSSet *)values;

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

- (void)addAttachmentsObject:(Attachment *)value;
- (void)removeAttachmentsObject:(Attachment *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

@end
