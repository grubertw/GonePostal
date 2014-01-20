//
//  GPSalesGroup.h
//  GonePostal
//
//  Created by Travis Gruber on 1/20/14.
//  Copyright (c) 2014 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, BureauPrecancel, Cachet, Cancelations, GPCatalog, GPCatalogGroup, GPCatalogSet, GPSalesGroupType, LocalPrecancel, LooksLike, Perfin, PlateNumber, Topic;

@interface GPSalesGroup : NSManagedObject

@property (nonatomic, retain) NSDate * lastDateUpdated;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * productDescription;
@property (nonatomic, retain) NSString * purchaseKey;
@property (nonatomic, retain) NSNumber * salePrice;
@property (nonatomic, retain) NSNumber * salesID;
@property (nonatomic, retain) NSString * version;
@property (nonatomic, retain) NSString * salesIDString;
@property (nonatomic, retain) NSSet *attachments;
@property (nonatomic, retain) NSSet *bureauPrecancels;
@property (nonatomic, retain) NSSet *cachets;
@property (nonatomic, retain) NSSet *cancelations;
@property (nonatomic, retain) NSSet *catalogEntries;
@property (nonatomic, retain) NSSet *catalogGroups;
@property (nonatomic, retain) NSSet *catalogSets;
@property (nonatomic, retain) NSSet *localPrecanels;
@property (nonatomic, retain) NSSet *looksLikes;
@property (nonatomic, retain) NSSet *perfinEntries;
@property (nonatomic, retain) NSSet *plateNumbers;
@property (nonatomic, retain) NSSet *topics;
@property (nonatomic, retain) GPSalesGroupType *salesGroupType;
@end

@interface GPSalesGroup (CoreDataGeneratedAccessors)

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

- (void)addCatalogEntriesObject:(GPCatalog *)value;
- (void)removeCatalogEntriesObject:(GPCatalog *)value;
- (void)addCatalogEntries:(NSSet *)values;
- (void)removeCatalogEntries:(NSSet *)values;

- (void)addCatalogGroupsObject:(GPCatalogGroup *)value;
- (void)removeCatalogGroupsObject:(GPCatalogGroup *)value;
- (void)addCatalogGroups:(NSSet *)values;
- (void)removeCatalogGroups:(NSSet *)values;

- (void)addCatalogSetsObject:(GPCatalogSet *)value;
- (void)removeCatalogSetsObject:(GPCatalogSet *)value;
- (void)addCatalogSets:(NSSet *)values;
- (void)removeCatalogSets:(NSSet *)values;

- (void)addLocalPrecanelsObject:(LocalPrecancel *)value;
- (void)removeLocalPrecanelsObject:(LocalPrecancel *)value;
- (void)addLocalPrecanels:(NSSet *)values;
- (void)removeLocalPrecanels:(NSSet *)values;

- (void)addLooksLikesObject:(LooksLike *)value;
- (void)removeLooksLikesObject:(LooksLike *)value;
- (void)addLooksLikes:(NSSet *)values;
- (void)removeLooksLikes:(NSSet *)values;

- (void)addPerfinEntriesObject:(Perfin *)value;
- (void)removePerfinEntriesObject:(Perfin *)value;
- (void)addPerfinEntries:(NSSet *)values;
- (void)removePerfinEntries:(NSSet *)values;

- (void)addPlateNumbersObject:(PlateNumber *)value;
- (void)removePlateNumbersObject:(PlateNumber *)value;
- (void)addPlateNumbers:(NSSet *)values;
- (void)removePlateNumbers:(NSSet *)values;

- (void)addTopicsObject:(Topic *)value;
- (void)removeTopicsObject:(Topic *)value;
- (void)addTopics:(NSSet *)values;
- (void)removeTopics:(NSSet *)values;

@end
