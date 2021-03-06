//
//  StampFormat.h
//  GonePostal
//
//  Created by Travis Gruber on 1/3/15.
//  Copyright (c) 2015 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Format, GPCatalog, GPCatalogAlbumSize, NumberOfStampsInPlate, Stamp, Valuation;

@interface StampFormat : NSManagedObject

@property (nonatomic, retain) NSNumber * displayBureauPrecancelInfo;
@property (nonatomic, retain) NSNumber * displayCachetInfo;
@property (nonatomic, retain) NSNumber * displayCancelationInfo;
@property (nonatomic, retain) NSNumber * displayLocalPrecancelInfo;
@property (nonatomic, retain) NSNumber * displayNumberOfStamps;
@property (nonatomic, retain) NSNumber * displayPerfinInfo;
@property (nonatomic, retain) NSNumber * displayPlateInfo;
@property (nonatomic, retain) NSNumber * modifiedByUser;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSSet *albumSizes;
@property (nonatomic, retain) NSSet *containers;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) NSSet *numberOfStampCombinations;
@property (nonatomic, retain) NSSet *stamps;
@property (nonatomic, retain) NSSet *values;
@end

@interface StampFormat (CoreDataGeneratedAccessors)

- (void)addAlbumSizesObject:(GPCatalogAlbumSize *)value;
- (void)removeAlbumSizesObject:(GPCatalogAlbumSize *)value;
- (void)addAlbumSizes:(NSSet *)values;
- (void)removeAlbumSizes:(NSSet *)values;

- (void)addContainersObject:(Format *)value;
- (void)removeContainersObject:(Format *)value;
- (void)addContainers:(NSSet *)values;
- (void)removeContainers:(NSSet *)values;

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addNumberOfStampCombinationsObject:(NumberOfStampsInPlate *)value;
- (void)removeNumberOfStampCombinationsObject:(NumberOfStampsInPlate *)value;
- (void)addNumberOfStampCombinations:(NSSet *)values;
- (void)removeNumberOfStampCombinations:(NSSet *)values;

- (void)addStampsObject:(Stamp *)value;
- (void)removeStampsObject:(Stamp *)value;
- (void)addStamps:(NSSet *)values;
- (void)removeStamps:(NSSet *)values;

- (void)addValuesObject:(Valuation *)value;
- (void)removeValuesObject:(Valuation *)value;
- (void)addValues:(NSSet *)values;
- (void)removeValues:(NSSet *)values;

@end
