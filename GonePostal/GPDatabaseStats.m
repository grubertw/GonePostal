//
//  GPDatabaseStats.m
//  GonePostal
//
//  Created by Travis Gruber on 7/7/13.
//  Copyright (c) 2013 Travis Gruber. All rights reserved.
//

#import "GPDatabaseStats.h"
#import "GPCatalog.h"

@interface GPDatabaseStats ()
@property (weak, nonatomic) IBOutlet NSTextField * numCatalogEntries;
@property (weak, nonatomic) IBOutlet NSTextField * numPicturesInCatalog;
@property (weak, nonatomic) IBOutlet NSTextField * numCachets;
@property (weak, nonatomic) IBOutlet NSTextField * numPlateCombinations;
@property (weak, nonatomic) IBOutlet NSTextField * numBureauPrecancels;
@property (weak, nonatomic) IBOutlet NSTextField * numCancelations;
@property (weak, nonatomic) IBOutlet NSTextField * numTopics;
@property (weak, nonatomic) IBOutlet NSTextField * numLooksLike;
@property (weak, nonatomic) IBOutlet NSTextField * numSets;

@property (weak, nonatomic) IBOutlet NSTextField * numLocalPrecancels;
@property (weak, nonatomic) IBOutlet NSTextField * numPerfins;
@property (weak, nonatomic) IBOutlet NSTextField * numStamps;
@property (weak, nonatomic) IBOutlet NSTextField * numAttachments;
@end

@implementation GPDatabaseStats

- (id)initWithWindow:(NSWindow *)window
{
    self = [super initWithWindow:window];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)windowDidLoad
{
    [super windowDidLoad];
    
    [self calculateStatics];
}

- (NSString *)windowTitleForDocumentDisplayName:(NSString *)displayName {
    return @"GonePostal Database Statistics";
}

- (void)calculateStatics {
    NSManagedObjectContext * managedObjectContext = [[self document] managedObjectContext];
    
    NSFetchRequest * gpCatalogFetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCatalog"];
    NSArray * gpCatalogResults = [managedObjectContext executeFetchRequest:gpCatalogFetch error:nil];
    if (gpCatalogResults && [gpCatalogResults count] > 0) {
        [self.numCatalogEntries setIntegerValue:[gpCatalogResults count]];
        
        NSInteger picCount = 0;
        for (GPCatalog * entry in gpCatalogResults) {
            if (entry.default_picture && ![entry.default_picture isEqualToString:@"empty"]) {
                picCount++;
            }
        }
        
        [self.numPicturesInCatalog setIntegerValue:picCount];
    }
    
    NSFetchRequest *cachetsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Cachet"];
    NSArray *cachets = [managedObjectContext executeFetchRequest:cachetsFetch error:nil];
    if (cachets && [cachets count] > 0) {
        [self.numCachets setIntegerValue:[cachets count]];
    }
    
    NSFetchRequest *plateCombosFetch = [NSFetchRequest fetchRequestWithEntityName:@"PlateNumber"];
    NSArray *plateCombos = [managedObjectContext executeFetchRequest:plateCombosFetch error:nil];
    if (plateCombos && [plateCombos count] > 0) {
        [self.numPlateCombinations setIntegerValue:[plateCombos count]];
    }
    
    NSFetchRequest *bureauPrecFetch = [NSFetchRequest fetchRequestWithEntityName:@"BureauPrecancel"];
    NSArray *bureauPrec = [managedObjectContext executeFetchRequest:bureauPrecFetch error:nil];
    if (bureauPrec && [bureauPrec count] > 0) {
        [self.numBureauPrecancels setIntegerValue:[bureauPrec count]];
    }
    
    NSFetchRequest *cancelFetch = [NSFetchRequest fetchRequestWithEntityName:@"Cancelations"];
    NSArray *cancel = [managedObjectContext executeFetchRequest:cancelFetch error:nil];
    if (cancel && [cancel count] > 0) {
        [self.numCancelations setIntegerValue:[cancel count]];
    }
    
    NSFetchRequest *topicsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Topic"];
    NSArray *topics = [managedObjectContext executeFetchRequest:topicsFetch error:nil];
    if (topics && [topics count] > 0) {
        [self.numTopics setIntegerValue:[topics count]];
    }
    
    NSFetchRequest *looksLikeFetch = [NSFetchRequest fetchRequestWithEntityName:@"LooksLike"];
    NSArray *looksLike = [managedObjectContext executeFetchRequest:looksLikeFetch error:nil];
    if (looksLike && [looksLike count] > 0) {
        [self.numLooksLike setIntegerValue:[looksLike count]];
    }
    
    NSFetchRequest *setsFetch = [NSFetchRequest fetchRequestWithEntityName:@"GPCatalogSet"];
    NSArray *sets = [managedObjectContext executeFetchRequest:setsFetch error:nil];
    if (sets && [sets count] > 0) {
        [self.numSets setIntegerValue:[sets count]];
    }
    
    NSFetchRequest *locPreFetch = [NSFetchRequest fetchRequestWithEntityName:@"LocalPrecancel"];
    NSArray *locPre = [managedObjectContext executeFetchRequest:locPreFetch error:nil];
    if (locPre && [locPre count] > 0) {
        [self.numLocalPrecancels setIntegerValue:[locPre count]];
    }
    
    NSFetchRequest *perfinsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Perfin"];
    NSArray *perfins = [managedObjectContext executeFetchRequest:perfinsFetch error:nil];
    if (perfins && [perfins count] > 0) {
        [self.numPerfins setIntegerValue:[perfins count]];
    }
    
    NSFetchRequest *stampsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Stamp"];
    NSArray *stamps = [managedObjectContext executeFetchRequest:stampsFetch error:nil];
    if (stamps && [stamps count] > 0) {
        [self.numStamps setIntegerValue:[stamps count]];
    }
    
    NSFetchRequest *attachmentsFetch = [NSFetchRequest fetchRequestWithEntityName:@"Attachment"];
    NSArray *attachments = [managedObjectContext executeFetchRequest:attachmentsFetch error:nil];
    if (attachments && [attachments count] > 0) {
        [self.numAttachments setIntegerValue:[attachments count]];
    }
}

- (IBAction)refresh:(id)sender {
    [self calculateStatics];
}

@end
