//
//  Country.h
//  GonePostal
//
//  Created by Travis Gruber on 6/29/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Attachment, GPCatalog, GPCatalogSet, LooksLike;

@interface Country : NSManagedObject

@property (nonatomic, retain) NSString * country_name;
@property (nonatomic, retain) NSNumber * country_sort_id;
@property (nonatomic, retain) NSSet *gpCatalogEntries;
@property (nonatomic, retain) NSSet *gpCatalogSets;
@property (nonatomic, retain) NSSet *looksLikes;
@property (nonatomic, retain) NSSet *attachments;
@end

@interface Country (CoreDataGeneratedAccessors)

- (void)addGpCatalogEntriesObject:(GPCatalog *)value;
- (void)removeGpCatalogEntriesObject:(GPCatalog *)value;
- (void)addGpCatalogEntries:(NSSet *)values;
- (void)removeGpCatalogEntries:(NSSet *)values;

- (void)addGpCatalogSetsObject:(GPCatalogSet *)value;
- (void)removeGpCatalogSetsObject:(GPCatalogSet *)value;
- (void)addGpCatalogSets:(NSSet *)values;
- (void)removeGpCatalogSets:(NSSet *)values;

- (void)addLooksLikesObject:(LooksLike *)value;
- (void)removeLooksLikesObject:(LooksLike *)value;
- (void)addLooksLikes:(NSSet *)values;
- (void)removeLooksLikes:(NSSet *)values;

- (void)addAttachmentsObject:(Attachment *)value;
- (void)removeAttachmentsObject:(Attachment *)value;
- (void)addAttachments:(NSSet *)values;
- (void)removeAttachments:(NSSet *)values;

@end
