//
//  GPSetController.swift
//  GonePostal
//
//  Created by Travis Gruber on 11/17/16.
//  Copyright © 2016 Travis Gruber. All rights reserved.
//

import Cocoa

internal class GPSetController: NSWindowController {
    
    let gpCatalogSetsSortDescriptors = [NSSortDescriptor(key:"name", ascending: true)] as NSArray
    let gpCatalogEntriesSortDescriptors = [NSSortDescriptor(key:"gp_catalog_number", ascending: true)] as NSArray
    let cachetsSortDescriptors = [NSSortDescriptor(key:"gp_cachet_number", ascending: true)] as NSArray
    let countrySortDescriptors = [NSSortDescriptor(key:"country_name", ascending: true)] as NSArray
    let sectionSortDescriptors = [NSSortDescriptor(key:"group_name", ascending: true)] as NSArray
    
    var managedObjectContext: NSManagedObjectContext
    
    @IBOutlet var gpCatalogSetsController: NSArrayController!
    @IBOutlet var gpCatalogsController: NSArrayController!
    @IBOutlet var cachetsController: NSArrayController!
    
    override var windowNibName: String! {
        return "GPSetController"
    }
    
    override init(window: NSWindow?) {
        let gpDocument = NSDocumentController.shared.currentDocument as! GPDocument
        managedObjectContext = gpDocument.managedObjectContext!
        
        super.init(window:window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented. use init(gpCatalog:)")
    }
    
    @IBAction func addSet(_ sender: AnyObject) {
        gpCatalogSetsController.insert(sender)
        save()
    }
    
    @IBAction func removeSet(_ sender: AnyObject) {
        gpCatalogSetsController.remove(sender)
        save()
    }
    
    @IBAction func addCatalogEntries(_ sender: AnyObject) {
        
    }
    
    @IBAction func removeCatalogEntries(_ sender: AnyObject) {
        gpCatalogsController.remove(contentsOf: self.gpCatalogsController.selectedObjects)
        save()
    }
    
    @IBAction func addCachets(_ sender: AnyObject) {
        if let selection = self.gpCatalogSetsController.selectedObjects {
            if (!selection.isEmpty) {
                let set = selection[0] as! GPCatalogSet
                let controller = GPCachetEditor(gpCatalogSet: set)
                self.document!.addWindowController(controller)
                controller.window!.makeKeyAndOrderFront(sender)
            }
        }
    }
    
    @IBAction func removeCachets(_ sender: AnyObject) {
        cachetsController.remove(contentsOf: self.cachetsController.selectedObjects)
        save()
    }
    
    func save() {
        do {
            try self.managedObjectContext.save()
        } catch {
            let alert = NSAlert(error: error)
            alert.beginSheetModal(for: self.window!, completionHandler: nil)
            self.managedObjectContext.rollback()
        }
    }
}
