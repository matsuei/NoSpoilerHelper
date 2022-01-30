//
//  SafariWebExtensionHandler.swift
//  SafariExtension
//
//  Created by Kenta Matsue on 2022/01/23.
//

import SafariServices
import os.log
import CoreData

class SafariWebExtensionHandler: NSObject, NSExtensionRequestHandling {
    
    private var persistentContainer: NSPersistentContainer {
        let container = NSPersistentContainer(name: "NoSpoilerHelper")
        let storeURL = URL.storeURL(for: "group.app.kenta.nospoiler.extension", databaseName: "NoSpoilerHelper")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            let items = try persistentContainer.viewContext.fetch(fetch) as! [Item]
            let words = items.map({$0.word!})
            let body: Dictionary<String, Array<String>> = ["words": words]
            let data = try JSONEncoder().encode(body)
            let json = String(data: data, encoding: .utf8) ?? ""
            let extensionItem = NSExtensionItem()
            extensionItem.userInfo = [ SFExtensionMessageKey: json ]
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
        } catch {
            fatalError("\(error)")
        }
    }

}

private extension URL {
    static func storeURL(for appGroup: String, databaseName: String) -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            fatalError("Shared file container could not be created.")
        }

        return fileContainer.appendingPathComponent("\(databaseName).sqlite")
    }
}
