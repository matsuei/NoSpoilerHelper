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
        let storeURL = URL.storeURL(for: "group.swiftlee.core.data", databaseName: "NoSpoilerHelper")
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        container.persistentStoreDescriptions = [storeDescription]
        return container
    }

    func beginRequest(with context: NSExtensionContext) {
        let item = context.inputItems[0] as! NSExtensionItem
        let message = item.userInfo?[SFExtensionMessageKey]
        os_log(.default, "Received message from browser.runtime.sendNativeMessage: %@", message as! CVarArg)
        
        let fetch = NSFetchRequest<NSFetchRequestResult>(entityName: "Item")
        do {
            // FIXME: データの取得がうまく行ってないので注意
            let items = try persistentContainer.viewContext.fetch(fetch) as! [Item]
        } catch {
            fatalError("\(error)")
        }
        let body: Dictionary<String, String> = ["type": "body"]
        do {
            let data = try JSONEncoder().encode(body)
            let json = String(data: data, encoding: .utf8) ?? ""
            let extensionItem = NSExtensionItem()
            extensionItem.userInfo = [ SFExtensionMessageKey: json ]
            context.completeRequest(returningItems: [extensionItem], completionHandler: nil)
        } catch {
            print("error")
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
