//
//  GPDocument.swift
//  GonePostal
//
//  Created by Travis Gruber on 9/8/19.
//  Copyright © 2019 Travis Gruber. All rights reserved.
//

import Cocoa
import os.log
import CommonCrypto

// Central class for the application. Follows in accordance with apple's
// document archetecture, subclassing NSPersistantDocument, which signifies
// the use of the Core Data framework. Primary overrides used are
// configurePersistentStoreCoordinator(), write(), and revert().
@objc(GPDocument) class GPDocument: NSPersistentDocument {
    // Static indexes into the CustomSearches table for fetching data.
    @objc static let ASSISTED_GP_CATALOG_EDITER_SEARCH_ID = 1
    @objc static let ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID = 2
    @objc static let ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID = 3
    @objc static let CUSTOM_GP_CATALOG_SEARCH_ID = 4
    @objc static let CUSTOM_STAMP_SEARCH_ID = 5
    @objc static let ASSISTED_LOOKS_LIKE_BROWSER_SEARCH_ID = 6
    @objc static let ASSISTED_SETS_BROWSER_SEARCH_ID = 7
    @objc static let ASSISTED_LOOKS_LIKE_EDITOR_SEARCH_ID = 8
    @objc static let CUSTOM_PLATE_NUMBERS_SEARCH_ID = 9
    
    // GP Collection types (identifiers)
    @objc static let GP_COLLECTION_TYPE_NORMAL = 1
    @objc static let GP_COLLECTION_TYPE_WANT_LIST = 2
    @objc static let GP_COLLECTION_TYPE_SELL_LIST = 3
    @objc static let GP_COLLECTION_TYPE_ITEMS_SOLD = 4
    
    @objc static let GPID_INCREMENT = 100
    
    // First level of valuation decision tree: a value for every stamp
    // format, per GPCatalog.
    @objc static let VALUATION_LEVEL_FORMAT = 1
    
    // Second level of decision tree: a value for every GPCatalog object
    // (ex: cachet, plate number).
    @objc static let VALUATION_LEVEL_OBJECT_OVERRIDE = 2
    
    // Third level of decision tree: a value for every stamp condition type
    @objc static let VALUATION_LEVEL_CONDITION_OVERRIDE = 3
    
    @objc static let BASE_GP_CATALOG_QUERY = "is_default==0 and composite_placeholder==0 and majorVariety==nil"
    @objc static let BASE_GP_CATALOG_QUERY_WITH_SUBVARIETIES = "is_default==0 and composite_placeholder==0"
    
    static let FILENAME_HASH_SALT = "p81VkYYb6d50wJ9aFmm0" // Salt for generating filename hashes.
    static let STORE_FILE_NAME = "CoreDataStore.sql" // Name of database within file wrapper.
    
    /// Used when importing fields into the GPWrapper.
    enum ImportFileType {
        case picture, pdf
    }
    
    // Public properties.
    @objc var gpCollectionSortDescriptors: Array<NSSortDescriptor>
    @objc var priceListSortDescriptors: Array<NSSortDescriptor>
    
    // Private properties from interface builder (i.e. the xib file).
    @IBOutlet private weak var mainWindow: NSWindow!
    @IBOutlet private weak var gpCollectionTable: NSTableView!
    @IBOutlet private weak var gpCollectionController: NSArrayController!
    
    override init() {
        gpCollectionSortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        priceListSortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        super.init()
        
        ValueTransformer.setValueTransformer(GPFilenameTransformer(document: self),
                                             forName: NSValueTransformerName("GPFilenameTransformer"))
        ValueTransformer.setValueTransformer(GPAlternateCatalogNumberTransformer(managedObjectContext: self.managedObjectContext),
            forName: NSValueTransformerName(rawValue: "GPAlternateCatalogNumberTransformer"))
        ValueTransformer.setValueTransformer(GPSearchSelectionTransformer(),
            forName: NSValueTransformerName(rawValue: "GPSearchSelectionTransformer"))
        ValueTransformer.setValueTransformer(GPEmptySetChecker(),
            forName: NSValueTransformerName(rawValue: "GPEmptySetChecker"))
        ValueTransformer.setValueTransformer(GPMultipleSelectionChecker(),
            forName: NSValueTransformerName(rawValue: "GPMultipleSelectionChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 1),
            forName: NSValueTransformerName(rawValue: "Plate1ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 2),
            forName: NSValueTransformerName(rawValue: "Plate2ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 3),
            forName: NSValueTransformerName(rawValue: "Plate3ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 4),
            forName: NSValueTransformerName(rawValue: "Plate4ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 5),
            forName: NSValueTransformerName(rawValue: "Plate5ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 6),
            forName: NSValueTransformerName(rawValue: "Plate6ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 7),
            forName: NSValueTransformerName(rawValue: "Plate7ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateUsageExistsChecker(plateNumberCheck: 8),
            forName: NSValueTransformerName(rawValue: "Plate8ExistsChecker"))
        ValueTransformer.setValueTransformer(GPPlateNumberMasterDisplayTransformer(),
            forName: NSValueTransformerName(rawValue: "GPPlateNumberMasterDisplayTransformer"))
        ValueTransformer.setValueTransformer(GPValuationCalculator(),
            forName: NSValueTransformerName(rawValue: "GPValuationCalculator"))
        ValueTransformer.setValueTransformer(GPSetCounter(),
            forName: NSValueTransformerName(rawValue: "GPSetCounter"))
        ValueTransformer.setValueTransformer(GPSellListLocator(),
            forName: NSValueTransformerName(rawValue: "GPSellListLocator"))
        ValueTransformer.setValueTransformer(GPCompositeTypeTransformer(),
            forName: NSValueTransformerName(rawValue: "GPCompositeTypeTransformer"))
        ValueTransformer.setValueTransformer(GPStampHasChildrenOrDetailTransformer(),
            forName: NSValueTransformerName(rawValue: "GPStampHasChildrenOrDetailTransformer"))
        ValueTransformer.setValueTransformer(GPStampDescriptionTransformer(),
            forName: NSValueTransformerName(rawValue: "GPStampDescriptionTransformer"))
        ValueTransformer.setValueTransformer(GPPictureTransformer(document: self),
            forName: NSValueTransformerName(rawValue: "GPPictureTransformer"))
        ValueTransformer.setValueTransformer(GPAllowedStampFormatsTransformer(),
            forName: NSValueTransformerName(rawValue: "GPAllowedStampFormatsTransformer"))
    }
    
    // Configures the store cordinator to use the database file inside the wrapper.
    override public func configurePersistentStoreCoordinator(for url: URL, ofType fileType: String, modelConfiguration configuration: String?, storeOptions: [String : Any]? = nil) throws {
        let storeURL = url.appendingPathComponent(GPDocument.STORE_FILE_NAME)
        let psc = self.managedObjectContext?.persistentStoreCoordinator
        
        // Attempt an automatic migration between versioned databases
        // (NOTE:  This will fail if this is a release that does not map
        // to a version in GPDocument.xdatamodeld)
        let optsForAutoMigration = [NSMigratePersistentStoresAutomaticallyOption: true, NSInferMappingModelAutomaticallyOption: true]
        
        try psc?.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: configuration, at: storeURL, options: optsForAutoMigration)
    }
    
    // Overridden NSDocument/NSPersistentDocument method to save documents.
    override public func writeSafely(to url: URL, ofType typeName: String, for saveOperation: NSDocument.SaveOperationType) throws {
        if (saveOperation == .saveAsOperation) {
            // Nothing exists at the URL: set up the directory and migrate the Core Data store.
            let fileWrapper = FileWrapper(directoryWithFileWrappers: [:])
            try fileWrapper.write(to: url, options: .atomic, originalContentsURL: nil)
            
            let storeURL = url.appendingPathComponent(GPDocument.STORE_FILE_NAME)
            
            if let originalURL = self.fileURL, let psc = self.managedObjectContext?.persistentStoreCoordinator {
                let origionalStoreURL = originalURL.appendingPathComponent(GPDocument.STORE_FILE_NAME)
                if let originalStore = psc.persistentStore(for: origionalStoreURL) {
                    // This is a "Save As", so migrate the store to the new URL.
                    try psc.migratePersistentStore(originalStore, to: storeURL, options: [:], withType: typeName)
                }
                else {
                    // This is the first Save of a new document, so add new store.
                    try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: [:])
                }
                
                // Create core data store wrapper and add to directory wrapper.
                let storeWrapper = try FileWrapper(url: storeURL, options: .immediate)
                fileWrapper.addFileWrapper(storeWrapper)
            }
            else {
                os_log("Error writing to GPDocument. self.fileURL or persistantStoreCordinator is null")
            }
        }
        
        // Save the Core Data portion of the document.
        try self.managedObjectContext?.save()
        
        // Set the appropriate file attributes (such as "Hide File Extension")
        try FileManager.default.setAttributes([FileAttributeKey.extensionHidden: true], ofItemAtPath: self.fileURL!.path)
    }
    
    /*
    The revert method needs to completely tear down the object graph assembled by the document. In this case, you also want to remove the persistent store manually, because NSPersistentDocument will expect the store for its coordinator to be located at the document URL (instead of inside that URL as part of the file wrapper).
    */
    override public func revert(toContentsOf inAbsoluteURL: URL, ofType inTypeName: String) throws {
        if let psc = self.managedObjectContext?.persistentStoreCoordinator {
            let storeURL = inAbsoluteURL.appendingPathComponent(GPDocument.STORE_FILE_NAME)
            
            if let store = psc.persistentStore(for: storeURL) {
                try psc.remove(store)
            }
        }
        try super.revert(toContentsOf: inAbsoluteURL, ofType: inTypeName)
    }
    
    override public var windowNibName: NSNib.Name? {
        return "GPDocument"
    }
    
    /// Get a starting GPID.
    /// Convert the last segment into a number that will be used in
    /// subsquent calls as an increment.
    @objc static func parseStartingID(_ gpid: String?) -> Int {
        if let lastGPIDSegment = gpid?.components(separatedBy: "-").last {
            return Int(lastGPIDSegment) ?? 1
        }
        else {return 1}
    }
    
    /// Get the static part of the GPID from the GPID.
    /// (the segments that will NOT increment)
    @objc static func parseStaticID(_ gpid: String?) -> String? {
        // Find where the last '-' occurs in the string.
        if let lastDash = gpid?.lastIndex(of: "-") {
            return String(gpid?.prefix(through: lastDash) ?? "")
        }
        else {return nil}
    }
    
    /// Invokes writeSafetyToURL method to save the persistant store in place.
    @objc func saveInPlace() {
        save(to: self.fileURL!,
             ofType: self.fileType!,
             for: .saveOperation,
             completionHandler: {(e: Error?) in
                if let error = e, let doc = NSDocumentController.shared.currentDocument {
                    let errSheet = NSAlert.init(error: error)
                    errSheet.beginSheetModal(for: doc.windowForSheet!, completionHandler: nil)
                }
        })
    }
    
    /// Propts the user for an image filename,
    /// only allowing one selection.  Returns the filename
    /// stored within the wrapper, i.e. the name stored
    /// in the database.
    ///
    /// Returns NIL if there is an error.
    func addFileToWrapper(usingGPID gpid: String,
                          forAttribute attributeName: String,
                          fileType type: ImportFileType) -> String? {
        var fileName: String? = nil
        
        // Get the absolute URL of the picture from the user.
        let chooser = NSOpenPanel()
        chooser.canChooseFiles = true
        chooser.canChooseDirectories = false
        chooser.allowsMultipleSelection = false
        chooser.allowedFileTypes = {() -> Array<String> in
            switch type {
            case .pdf: return ["pdf"]
            case .picture: return ["jpg", "png"]
            }
        }()
        
        let rc = chooser.runModal()
        if (rc != NSApplication.ModalResponse.OK) {
            return fileName
        }
        
        // Get the URL from the dialog.
        let fileURL = chooser.urls[0]
        do {
            let fileWrapper = try FileWrapper(url:fileURL, options:FileWrapper.ReadingOptions.immediate)
            
            fileName = hashFileName(forGPID: gpid, andAttributeName: attributeName)
            fileWrapper.preferredFilename = fileName
            
            let newURL = self.fileURL!.appendingPathComponent(fileName!)
            
            // Copy the file into a wrapper (i.e. node)
            try fileWrapper.write(to: newURL, options: FileWrapper.WritingOptions.withNameUpdating, originalContentsURL: fileURL)
            
            // Copy into the GPWrapper
            let gpWrapper = try FileWrapper(url: newURL, options: FileWrapper.ReadingOptions.immediate)
            gpWrapper.addFileWrapper(fileWrapper)
        } catch let error as NSError {
            os_log("Error adding file into GPWrapper: %@, %@", error, error.userInfo)
        }
        return fileName
    }
    
    // Since Objective-C does not support swift enums, provide conveniance functions
    // for adding either an image or pdf into the file wrapper.
    @objc func addImageToWrapper(usingGPID gpid: String, forAttribute attributeName: String) -> String? {
        return addFileToWrapper(usingGPID: gpid, forAttribute: attributeName, fileType: ImportFileType.picture)
    }
    @objc func addPDFToWrapper(usingGPID gpid: String, forAttribute attributeName: String) -> String? {
        return addFileToWrapper(usingGPID: gpid, forAttribute: attributeName, fileType: ImportFileType.pdf)
    }
    
    // Creates a crypographic hash of the filename for a GPID.
    // The attribute field should objectify the GPID in some way,
    // such as the class name for the GPID in question.
    @objc func hashFileName(forGPID gpid:String, andAttributeName attributeName:String) -> String {
        // Create string to feed into the hasher.
        let stringToHash = "\(gpid)\(attributeName)\(GPDocument.FILENAME_HASH_SALT)"
        
        // Compute SHA1 hash.
        let data = Data(stringToHash.utf8)
        var digest = [UInt8](repeating: 0, count:Int(CC_SHA1_DIGEST_LENGTH))
        let hash: String = data.withUnsafeBytes {
            _ = CC_SHA1($0.baseAddress, CC_LONG(data.count), &digest)
            let asciiHexStr = digest.map {String(format: "%02hhx", $0)}
            return asciiHexStr.joined()
        }
        
        return hash
    }
    
    @IBAction func addGPCollection(_ sender: Any) {
        let newCollection = NSEntityDescription.insertNewObject(forEntityName: "GPCollection", into: self.managedObjectContext!) as! GPCollection
        newCollection.name = "New Collection"
        newCollection.type = GPDocument.GP_COLLECTION_TYPE_NORMAL as NSNumber
        self.gpCollectionController.addObject(newCollection)
        
        // Create the sold stamps collection if it does not exist.
        let collectionFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "GPCollection")
        let soldListSearch = NSPredicate.init(format: "type == 4")
        collectionFetch.predicate = soldListSearch
        
        do {
            let results = try self.managedObjectContext?.fetch(collectionFetch)
            if (results?.count == 0) {
                let soldList = NSEntityDescription.insertNewObject(forEntityName: "GPCollection", into: self.managedObjectContext!) as! GPCollection
                soldList.type = GPDocument.GP_COLLECTION_TYPE_ITEMS_SOLD as NSNumber
            }
            
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            os_log("Error searching for sold list for new GPCollection: %@, %@", error, error.userInfo)
            
            let errSheet = NSAlert.init(error: error)
            errSheet.beginSheetModal(for: self.mainWindow, completionHandler: nil)
        }
    }
    
    @IBAction func removeGPCollection(_ sender: Any) {
        self.gpCollectionController.remove(sender)
        
        do {
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            let errSheet = NSAlert.init(error: error)
            errSheet.beginSheetModal(for: self.mainWindow, completionHandler: nil)
        }
    }
    
    @IBAction func openGPCatalog(_ sender: Any) {
        let assistedSearch = AssistedSearch(self.managedObjectContext!)
        assistedSearch.load(GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID)
        
        let catalogEditor = GPCatalogEditor.init(assistedSearch: assistedSearch.search, countrySearch: assistedSearch.countriesPredicate, sectionSearch: assistedSearch.sectionsPredicate, filterSearch: assistedSearch.filtersPredicate)
        
        self.addWindowController(catalogEditor!)
        catalogEditor?.window?.makeKeyAndOrderFront(self)
    }
    
    @IBAction func openImport(_ sender: Any) {
        let c = GPImportController.init(windowNibName: "GPImportController")
        self.addWindowController(c)
        c.window?.makeKeyAndOrderFront(self)
    }
    
    @IBAction func openLibrary(_ sender:Any) {
        let c = GPAttachmentController.init(windowNibName: "GPAttachmentController")
        c.managedObjectContext = self.managedObjectContext
        
        self.addWindowController(c)
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    @IBAction func showCatalogStats(_ sender:Any) {
        let c = GPDatabaseStats.init(windowNibName: "GPDatabaseStats")
        self.addWindowController(c)
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    @IBAction func recalculateValueOfCollection(_ sender:Any) {
        let selection = self.gpCollectionController.selectedObjects
        
        if let s = selection, s.count >= 1 {
            let collection = s[0] as! GPCollection
            
            collection.value = (collection.stamps as! Set<Stamp>).reduce(0.0) {i, x in
                i + (x.manual_value?.floatValue ?? 0.0)
            } as NSNumber
        }
    }
    
    @IBAction func viewStamps(_ sender:Any) {
        let selection = self.gpCollectionController.selectedObjects
        
        if let s = selection, s.count >= 1 {
            let assistedSearch = AssistedSearch(self.managedObjectContext!)
            assistedSearch.load(GPDocument.ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID)
            
            let stampViewer = GPStampViewer.init(collection: s[0] as? GPCollection, assistedSearch: assistedSearch.search, countrySearch: assistedSearch.countriesPredicate, sectionSearch: assistedSearch.sectionsPredicate, formatSearch: assistedSearch.formatsPredicate, locationSearch: assistedSearch.locationsPredicate)
            
            self.addWindowController(stampViewer!)
            stampViewer?.window?.makeKeyAndOrderFront(self)
        }
    }
    
    @IBAction func deleteStampsAndCollections(_ sender:Any) {
        do {
            let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Stamp")
            let stamps = (try self.managedObjectContext?.fetch(req))!
            for s in stamps {
                self.managedObjectContext?.delete(s as! NSManagedObject)
            }
            
            let cReq = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GPCollection")
            let collections = (try self.managedObjectContext?.fetch(cReq))!
            for c in collections {
                self.managedObjectContext?.delete(c as! NSManagedObject)
            }
        } catch let error as NSError {
            let errSheet = NSAlert.init(error: error)
            errSheet.beginSheetModal(for: self.mainWindow, completionHandler: nil)
        }
    }
    
    @IBAction func pushAllowedStampFormatsIntoCatalog(_ sender:Any) {
        do {
            let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "GPCatalog")
            req.predicate = NSPredicate.init(format: "is_default == 0")
            
            let entries = (try self.managedObjectContext?.fetch(req)) as! Array<GPCatalog>
            for e in entries {
                e.addAllowedStampFormats(e.formatType.allowedStampFormats)
            }
            
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            let errSheet = NSAlert.init(error: error)
            errSheet.beginSheetModal(for: self.mainWindow, completionHandler: nil)
        }
    }
    
    @IBAction func renumberStampIDs(_ sender:Any) {
        do {
            let req = NSFetchRequest<NSFetchRequestResult>.init(entityName: "Stamp")
            req.predicate = NSPredicate.init(format: "is_default == YES")
            
            let results = try self.managedObjectContext?.fetch(req) as! Array<Stamp>
            
            // Defaults must be created if they dont exist.
            let defaults = ((results.count == 0) ? NSEntityDescription.insertNewObject(forEntityName: "Stamp", into: self.managedObjectContext!) : results[0]) as! Stamp
            
            // Now fetch all regular stamps.
            req.predicate = NSPredicate.init(format: "is_default == NO")
            let stamps = try self.managedObjectContext?.fetch(req) as! Array<Stamp>
            
            if (stamps.count > 0) {
                // Sort the stamps first by catalog number, then by stamp format
                let sorted = stamps.sorted {
                    $0.gpCatalog!.gp_catalog_number > $1.gpCatalog!.gp_catalog_number
                }.sorted {
                    $0.format!.name > $1.format!.name
                }
                
                var stampIDCounter = 1;
                for s in sorted {
                    s.gp_stamp_number = String(format: "%ld", stampIDCounter)
                    stampIDCounter += 1
                }
                
                defaults.gp_stamp_number = String(format: "%ld", stampIDCounter)
            }
            
            try self.managedObjectContext?.save()
        } catch let error as NSError {
            let errSheet = NSAlert.init(error: error)
            errSheet.beginSheetModal(for: self.mainWindow, completionHandler: nil)
        }
    }
    
    func openGPCatalogDefaults(_ sender:Any) {
        let c = GPCatalogDefaults.init(windowNibName: "GPCatalogDefaults")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func openStampDefaults(_ sender:Any) {
        let c = GPStampDefaults.init(windowNibName: "GPStampDefaults")
        self.addWindowController(c)
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func openSaleHistoryDefaults(_ sender:Any) {
        let c = GPSaleHistoryDefaults.init(windowNibName: "GPSaleHistoryDefaults")
        self.addWindowController(c)
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCountried(_ sender:Any) {
        let c = GPSupportedCountriesController.init(windowNibName: "GPSupportedCountriesController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedFormats(_ sender:Any) {
        let c = GPSupportedFormatsController.init(windowNibName: "GPSupportedFormatsController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedAltCatalogNames(_ sender:Any) {
        let c = GPSupportedAltCatalogNamesController.init(windowNibName: "GPSupportedAltCatalogNamesController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedAltCatalogSections(_ sender:Any) {
        let c = GPSupportedAltCatalogSectionsController.init(windowNibName: "GPSupportedAltCatalogSectionsController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedGroups(_ sender:Any) {
        let c = GPSupportedGroupsController.init(windowNibName: "GPSupportedGroupsController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedPlatePositions(_ sender:Any) {
        let c = GPPlatePositionsController.init(windowNibName: "GPPlatePositionsController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCachetCatalogs(_ sender:Any) {
        let c = GPSupportedCachetCatalogsController.init(windowNibName: "GPSupportedCachetCatalogController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCachetMakers(_ sender:Any) {
        let c = GPSupportedCachetMakersController.init(windowNibName: "GPSupportedCachetMakersController")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCancelQuality(_ sender:Any) {
        let c = GPSupportedCancelQuality.init(windowNibName: "GPSupportedCancelQuality")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCentering(_ sender:Any) {
        let c = GPSupportedCentering.init(windowNibName: "GPSupportedCentering")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedDealers(_ sender:Any) {
        let c = GPSupportedDealers.init(windowNibName: "GPSupportedDealers")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedStampFormats(_ sender:Any) {
        let c = GPSupportedStampFormats.init(windowNibName: "GPSupportedStampFormats")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedGrades(_ sender:Any) {
        let c = GPSupportedGrades.init(windowNibName: "GPSupportedGrades")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedGumConditions(_ sender:Any) {
        let c = GPSupportedGumConditions.init(windowNibName: "GPSupportedGumConditions")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedHinged(_ sender:Any) {
        let c = GPSupportedHinged.init(windowNibName: "GPSupportedHinged")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedLocations(_ sender:Any) {
        let c = GPSupportedLocations.init(windowNibName: "GPSupportedLocations")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedLots(_ sender:Any) {
        let c = GPSupportedLots.init(windowNibName: "GPSupportedLots")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedMounts(_ sender:Any) {
        let c = GPSupportedMounts.init(windowNibName: "GPSupportedMounts")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedSoundness(_ sender:Any) {
        let c = GPSupportedSoundness.init(windowNibName: "GPSupportedSoundness")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedLocalPrecancels(_ sender:Any) {
        let c = GPSupportedLocalPrecancels.init(windowNibName: "GPSupportedLocalPrecancels")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedPerfins(_ sender:Any) {
        let c = GPSupportedPerfins.init(windowNibName: "GPSupportedPerfins")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedPerfinCatalogs(_ sender:Any) {
        let c = GPSupportedPerfinCatalogs.init(windowNibName: "GPSupportedPerfinCatalogs")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedSubvarietyTypes(_ sender:Any) {
        let c = GPSupportedSubvarietyTypes.init(windowNibName: "GPSupportedSubvarietyTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedSubjects(_ sender:Any) {
        let c = GPSupportedSubjects.init(windowNibName: "GPSupportedSubjects")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedPriceLists(_ sender:Any) {
        let c = GPSupportedPriceLists.init(windowNibName: "GPSupportedPriceLists")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedSalesGroups(_ sender:Any) {
        let c = GPSalesGroupEditor.init(windowNibName: "GPSalesGroupEditor")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedSalesGroupTypes(_ sender:Any) {
        let c = GPSupportedSalesGroupTypes.init(windowNibName: "GPSupportedSalesGroupTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCatalogDataTypes(_ sender:Any) {
        let c = GPSupportedCatalogDateTypes.init(windowNibName: "GPSupportedCatalogDateTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedCatalogPeopleTypes(_ sender:Any) {
        let c = GPSupportedCatalogPeopleTypes.init(windowNibName: "GPSupportedCatalogPeopleTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedPlateSizeTypes(_ sender:Any) {
        let c = GPSupportedPlateSizeTypes.init(windowNibName: "GPSupportedPlateSizeTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    func editSupportedGPCatalogQuantityTypes(_ sender:Any) {
        let c = GPSupportedCatalogQuantityTypes.init(windowNibName: "GPSupportedCatalogQuantityTypes")
        self.addWindowController(c)
        c.managedObjectContext = self.managedObjectContext
        c.window?.makeKeyAndOrderFront(sender)
    }
    
    /// Used to run the first search/filter on several controllers
    /// within the program, when they first load.
    ///
    /// A StoredSearch from the managed object context (i.e. the database) is queried.
    /// If the StoredSearch object is found, it is saved and then parsed into it's component
    /// predicate queries.
    class AssistedSearch {
        var search: StoredSearch?
        var countriesPredicate: NSPredicate?
        var sectionsPredicate: NSPredicate?
        var filtersPredicate: NSPredicate?
        var formatsPredicate: NSPredicate?
        var locationsPredicate: NSPredicate?
        var managedObjectContext: NSManagedObjectContext
        
        init(_ managedObjectContext: NSManagedObjectContext) {
            self.managedObjectContext = managedObjectContext
        }
        
        func load(_ searchID: Int) {
            // Build query to execute on the object context
            let request = NSFetchRequest<NSFetchRequestResult>.init(entityName: "StoredSearch")
            request.predicate = NSPredicate.init(format: "identifier==%ld", searchID)
            
            do {
                let results = try self.managedObjectContext.fetch(request)
                
                if (results.count == 1) {
                    self.search = results[0] as? StoredSearch
                    
                    // Parse the stored search into it's component predicates.
                    
                }
                else {
                    if (   searchID == GPDocument.ASSISTED_GP_CATALOG_EDITER_SEARCH_ID
                        || searchID == GPDocument.ASSISTED_GP_CATALOG_BROWSER_SEARCH_ID) {
                        // Create the query from the factory default.
                        self.search = NSEntityDescription.insertNewObject(forEntityName: "StoredSearch", into: self.managedObjectContext) as? StoredSearch
                        self.search?.predicate = NSPredicate.init(format: GPDocument.BASE_GP_CATALOG_QUERY)
                    }
                    else if (   searchID == ASSISTED_STAMP_LIST_VIEWER_SEARCH_ID
                             || searchID == ASSISTED_LOOKS_LIKE_BROWSER_SEARCH_ID
                             || searchID == ASSISTED_LOOKS_LIKE_EDITOR_SEARCH_ID) {
                        // Leave predicate empty until user enters a search.
                        self.search = NSEntityDescription.insertNewObject(forEntityName: "StoredSearch", into: self.managedObjectContext) as? StoredSearch
                    }
                    
                    self.search?.identifier = searchID as NSNumber
                }
            } catch let error as NSError {
                os_log("error loading assisted search: %@, %@", error, error.userInfo)
            }
        }
        
        // Parse through predicate in a StoredSearch, breaking it down into it's component
        // pieces. Further parsing of the subpredicate is down later in the indivual window
        // search controllers.
        func parse(_ search: NSPredicate, _ parentSearch: NSPredicate?) {
            if (search is NSCompoundPredicate) {
                let subPreds = (search as! NSCompoundPredicate).subpredicates
                
                for sub in subPreds {
                    // Recursivly call into this method to determine the comparison type.
                    self.parse(sub as! NSPredicate, search)
                }
            }
            else if (search is NSComparisonPredicate) {
                let leftExpression = (search as! NSComparisonPredicate).leftExpression
                
                if (leftExpression.expressionType == NSExpression.ExpressionType.keyPath) {
                    // Determine if the representing presidcate needs to be this presicate or the parent.
                    let representingPred = (parentSearch == nil || parentSearch == self.search?.predicate) ? search : parentSearch
                    
                    if (   leftExpression.keyPath == "country.country_sort_id"
                        || leftExpression.keyPath == "gpCatalog.country.country_sort_id") {
                        self.countriesPredicate = representingPred
                    }
                    else if (   leftExpression.keyPath == "catalogGroup.group_number"
                             || leftExpression.keyPath == "gpCatalog.catalogGroup.group_number") {
                        self.sectionsPredicate = representingPred
                    }
                    else if (leftExpression.keyPath == "format.name") {
                        self.formatsPredicate = representingPred
                    }
                    else if (leftExpression.keyPath == "location.name") {
                        self.locationsPredicate = representingPred
                    }
                    else if (   leftExpression.keyPath != "is_default"
                             && leftExpression.keyPath != "composite_placeholder"
                             && leftExpression.keyPath != "majorVariety"
                             && leftExpression.keyPath != "looksLike.name") {
                        self.filtersPredicate = representingPred
                    }
                }
            }
        }
    }
    
    // Maintain the same assisted search interface to the objective-c code untill it can be rewritten.
    @objc func loadAssistedSearch(_ searchID: Int) {
        let ass = AssistedSearch(self.managedObjectContext!)
        ass.load(searchID)
        self.assistedSearch = ass.search
        self.countriesPredicate = ass.countriesPredicate
        self.sectionsPredicate = ass.sectionsPredicate
        self.filtersPredicate = ass.filtersPredicate
        self.formatsPredicate = ass.formatsPredicate
        self.locationsPredicate = ass.locationsPredicate
    }
    @objc var assistedSearch: StoredSearch?
    @objc var countriesPredicate: NSPredicate?
    @objc var sectionsPredicate: NSPredicate?
    @objc var filtersPredicate: NSPredicate?
    @objc var formatsPredicate: NSPredicate?
    @objc var locationsPredicate: NSPredicate?
}
