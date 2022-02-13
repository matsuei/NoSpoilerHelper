//
//  ContentView.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/01/23.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.createdAt, ascending: true)],
        animation: .default)
    private var items: FetchedResults<Item>
    
    @State private var showingModal = false
    @State private var showingHowToUse = false
    @State private var hasShownHowToUse = false

    var body: some View {
        NavigationView {
            ZStack {
                Text("Add Word From Above Plus Button")
                if !items.isEmpty {
                    List {
                        ForEach(items) { item in
                            Text(item.word ?? "text")
                        }
                        .onDelete(perform: deleteItems)
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        self.showingHowToUse = true
                    } label: {
                        Label("Add Item", systemImage: "questionmark")
                    }
                    .sheet(isPresented: $showingHowToUse) {
                        HowToUseView()
                    }
                    .disabled(items.isEmpty)
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button {
                        self.showingModal = true
                    } label: {
                        Label("Add Item", systemImage: "plus")
                    }
                    .sheet(isPresented: $showingModal, onDismiss: {
                        if items.isEmpty || self.hasShownHowToUse { return }
                        self.showingHowToUse = true
                        self.hasShownHowToUse = true
                    }) {
                        AddWordView()
                                        .environment(\.managedObjectContext, viewContext)
                                }
                }
            }
            .sheet(isPresented: $showingHowToUse) {
                HowToUseView()
            }
        }
    }

    private func addItem() {
        withAnimation {
            let newItem = Item(context: viewContext)
            newItem.word = "word"

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

private let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .medium
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
