//
//  GPAddCachet.swift
//  GonePostal
//
//  Created by Travis Gruber on 6/6/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

import Cocoa

internal class GPAddCachet: NSWindowController, NSWindowDelegate {

    override var windowNibName: String! {
        return "GPAddCachet"
    }
    
    let cachetSortDescriptors = [NSSortDescriptor(key:"gp_cachet_number", ascending: true)] as NSArray
    let cachetCatalogNameSortDescriptors = [NSSortDescriptor(key:"cachet_catalog_name", ascending: true)] as NSArray
    let cachetMakerNameSortDescriptors = [NSSortDescriptor(key:"cachet_maker_name", ascending: true)] as NSArray
    let salesGroupSortDescriptors = [NSSortDescriptor(key:"name", ascending: true)] as NSArray
    
    var savePressed: Bool
    var gpCatalog: GPCatalog?
    var gpCatalogSet: GPCatalogSet?
    var managedObjectContect: NSManagedObjectContext
    var doc: GPDocument!
    
    @IBOutlet weak var cachetController: NSObjectController!
    @IBOutlet weak var addedCachetsController: NSArrayController!
    @IBOutlet weak var addMoreQuantityTextBox: NSTextField!
    
    init(gpCatalog: GPCatalog) {
        self.savePressed = false
        self.gpCatalog = gpCatalog
        self.managedObjectContect = gpCatalog.managedObjectContext!
        
        super.init(window: nil)
    }
    
    init(gpCatalogSet: GPCatalogSet) {
        self.savePressed = false
        self.gpCatalogSet = gpCatalogSet
        self.managedObjectContect = gpCatalogSet.managedObjectContext!
        
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. use init(gpCatalog:)")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.doc = (self.document as! GPDocument)
        
        do {
            try self.managedObjectContect.save();
            
            let cachet = NSEntityDescription.insertNewObject(forEntityName: "Cachet", into: self.managedObjectContect) as! Cachet
            cachet.gp_cachet_number = self.gpCatalog?.gp_catalog_number
            cachet.gp_cachet_number = self.gpCatalogSet?.gp_set_number
            self.cachetController.content = cachet
        } catch {
            let saveError = error as NSError
            let alert = NSAlert(error: saveError)
            alert.beginSheetModal(for: self.window!, completionHandler: nil)
        }
    }
    
    override func windowTitle(forDocumentDisplayName displayName: String) -> String {
        return "Add a Cachet"
    }
    
    @IBAction func addMoreCachets(_ sender: AnyObject) {
        let cachet: Cachet = self.cachetController.content as! Cachet
        
        self.gpCatalog?.addCachetsObject(cachet)
        self.gpCatalogSet?.addCachetsObject(cachet)
        self.addedCachetsController.addObject(cachet)
        
        // Get the incrementing and non incrementing part of the GPID
        let staticID = GPDocument.parseStaticID(cachet.gp_cachet_number)
        var startingID = GPDocument.parseStartingID(cachet.gp_cachet_number)
        
        let count = self.addMoreQuantityTextBox.integerValue
        if count > 1 {
            // Duplicate the Cachet from the model controller.
            for _ in 2...count {
                startingID += GPDocument.GPID_INCREMENT
                let dup = cachet.duplicate()
                dup.gp_cachet_number = String(format: "%@%08ld",staticID!, startingID)
                self.gpCatalog?.addCachetsObject(dup)
                self.gpCatalogSet?.addCachetsObject(dup)
                self.addedCachetsController.addObject(dup)
            }
        }
        
        do {
            try self.managedObjectContect.save()
        } catch {
            let saveError = error as NSError
            let alert = NSAlert(error: saveError)
            alert.beginSheetModal(for: self.window!, completionHandler: nil)
            self.managedObjectContect.rollback()
        }
        
        // Prepare for the next entry.
        let nextCachet = cachet.duplicate()
        startingID += GPDocument.GPID_INCREMENT
        nextCachet.gp_cachet_number = String(format: "%@%08ld",staticID!, startingID)
        self.cachetController.content = nextCachet
    }
    
    @IBAction func saveCachet(_ sender: AnyObject) {
        self.savePressed = true
        
        let cachet: Cachet = self.cachetController.content as! Cachet
        self.gpCatalog?.addCachetsObject(cachet)
        self.gpCatalogSet?.addCachetsObject(cachet)
        
        // Get the incrementing and non incrementing part of the GPID
        let staticID = GPDocument.parseStaticID(cachet.gp_cachet_number)
        var startingID = GPDocument.parseStartingID(cachet.gp_cachet_number)
        
        let count = self.addMoreQuantityTextBox.integerValue
        if count > 1 {
            // Duplicate the Cachet from the model controller.
            for _ in 2...count {
                startingID += GPDocument.GPID_INCREMENT
                let dup = cachet.duplicate()
                dup.gp_cachet_number = String(format: "%@%08ld",staticID!, startingID)
                self.gpCatalog?.addCachetsObject(dup)
                self.gpCatalogSet?.addCachetsObject(dup)
            }
        }
        
        do {
            try self.managedObjectContect.save()
        } catch {
            let saveError = error as NSError
            let alert = NSAlert(error: saveError)
            alert.beginSheetModal(for: self.window!, completionHandler: nil)
            self.managedObjectContect.rollback()
        }
        self.close()
    }

    @IBAction func cancelCachet(_ sender: AnyObject) {
        self.close()
    }
    
    func windowWillClose(_ notification: Notification) {
        if !self.savePressed {
            self.managedObjectContect.rollback()
        }
    }
    
    @IBAction func addPicture(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.cachet_picture = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.default_picture", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAlternatePic1(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_1 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_1", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAlternatePic2(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_2 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_2", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAlternatePic3(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_3 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_3", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAltPic4(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_4 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_4", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAltPic5(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_5 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_5", fileType: GPDocument.ImportFileType.picture)
        }
    }
    
    @IBAction func addAltPic6(_ sender: AnyObject) {
        if let entry = self.cachetController.content as? Cachet {
            entry.alternate_picture_6 = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number!, forAttribute: "Cachet.alternate_picture_6", fileType: GPDocument.ImportFileType.picture)
        }
    }
}
