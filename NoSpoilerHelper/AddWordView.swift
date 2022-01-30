//
//  AddWordView.swift
//  NoSpoilerHelper
//
//  Created by Kenta Matsue on 2022/01/30.
//

import SwiftUI

struct AddWordView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @State private var word: String = ""
    @Environment(\.presentationMode) private var presentationMode
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    TextField("word", text: $word)
                        .disableAutocorrection(true)
                }
            }
            .listStyle(InsetGroupedListStyle())
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("register") {
                        addItem()
                    }
                }
            }
        }
    }
    
    private func addItem() {
        let newItem = Item(context: viewContext)
        newItem.id = UUID()
        newItem.word = word

        do {
            try viewContext.save()
            presentationMode.wrappedValue.dismiss()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct AddWordView_Previews: PreviewProvider {
    static var previews: some View {
        AddWordView()
    }
}
