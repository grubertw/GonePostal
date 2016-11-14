//
//  GPCachetEditor.swift
//  GonePostal
//
//  Created by Travis Gruber on 6/4/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

import Cocoa

internal class GPCachetEditor: NSWindowController {

    override var windowNibName: String! {
        return "GPCachetEditor"
    }
    
    let cachetSortDescriptors: [NSSortDescriptor]
    let cachetCatalogNameSortDescriptors: [NSSortDescriptor]
    let cachetMakerNameSortDescriptors: [NSSortDescriptor]
    let salesGroupSortDescriptors: [NSSortDescriptor]
    
    var gpCatalog: GPCatalog
    var managedObjectContect: NSManagedObjectContext
    var doc: GPDocument!
    
    @IBOutlet var cachetController: NSArrayController!
    
    init(gpCatalog: GPCatalog) {
        self.cachetSortDescriptors = [NSSortDescriptor(key:"gp_cachet_number", ascending: true)]
        self.cachetCatalogNameSortDescriptors = [NSSortDescriptor(key:"cachet_catalog_name", ascending: true)]
        self.cachetMakerNameSortDescriptors = [NSSortDescriptor(key:"cachet_maker_name", ascending: true)]
        self.salesGroupSortDescriptors = [NSSortDescriptor(key:"name", ascending: true)]
        
        self.gpCatalog = gpCatalog
        self.managedObjectContect = gpCatalog.managedObjectContext!
        
        super.init(window: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. use init(gpCatalog:)")
    }
    
    override func windowDidLoad() {
        super.windowDidLoad()

        self.doc = self.document as! GPDocument
    }
    
    @IBAction func addCachet(_ sender: AnyObject) {
        let controller = GPAddCachet(gpCatalog: self.gpCatalog)
        self.doc.addWindowController(controller)
        controller.window!.makeKeyAndOrderFront(sender)
    }
    
    @IBAction func removeCachet(_ sender: AnyObject) {
        self.cachetController.remove(sender)
    }
    
    @IBAction func duplicateCachet(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            for entry in entries as! [Cachet] {
                // Extract static ID from GPID (same for all Cachets in catalog entry)
                let staticID = GPDocument.parseStaticID(entry.gp_cachet_number)
                var startingID = GPDocument.parseStartingID(entry.gp_cachet_number)
                startingID += GPID_INCREMENT
                
                let dup = entry.duplicate()
                dup.gp_cachet_number = String(format:"%@%08ld",staticID!, startingID)
                
                self.gpCatalog.addCachetsObject(dup)
            }
        }
    }
    
    @IBAction func saveEdits(_ sender: AnyObject) {
        do {
            try self.managedObjectContect.save();
            self.close()
        } catch {
            let saveError = error as NSError
            let alert = NSAlert(error: saveError)
            alert.beginSheetModal(for: self.window!, completionHandler: nil)
            self.managedObjectContect.undo()
        }
    }
    
    @IBAction func cancelEdits(_ sender: AnyObject) {
        self.managedObjectContect.undo()
        self.close()
    }
    
    @IBAction func setDefaultPicture(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.default_picture", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.cachet_picture = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture1(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_1", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_1 = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture2(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_2", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_2 = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture3(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_3", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_3 = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture4(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_4", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_4 = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture5(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_5", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_5 = fileNameU
                    }
                }
            }
        }
    }
    
    @IBAction func setAlternatePicture6(_ sender: AnyObject) {
        if let entries = self.cachetController.selectedObjects {
            if entries.count > 0 {
                if let entry = entries[0] as? Cachet {
                    let fileName: String? = self.doc.addFileToWrapper(usingGPID: entry.gp_cachet_number, forAttribute:"Cachet.alternate_picture_6", fileType:GPImportFileTypePicture)
                    
                    if let fileNameU = fileName {
                        entry.alternate_picture_6 = fileNameU
                    }
                }
            }
        }
    }
}
