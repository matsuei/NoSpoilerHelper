//
//  NoSpoilerHelperApp.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/01/23.
//

import SwiftUI

@main
struct NoSpoilerHelperApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
