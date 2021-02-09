//
//  ContentView.swift
//  Shared
//
//  Created by Дмитрий Лисин on 18.01.2021.
//

import CoreData
import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @State private var isShowSettings: Bool = false
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Item.passwordName, ascending: true)],
        animation: .default
    )
    private var items: FetchedResults<Item>
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            try? viewContext.save()
        }
    }
    
    private func showSettings() {
        isShowSettings = true
    }
    
    var settingsButton: some View {
        Button(action: showSettings) {
            Image(systemName: "plus.circle.fill")
                .imageScale(.large)
        }
        .keyboardShortcut("a", modifiers: .command)
        .help("help_title_add_button")
    }
    
    var body: some View {
        List {
            ForEach(items, content: ListItem.init)
                .onDelete(perform: deleteItems)
        }
        .customListStyle()
        .environment(\.defaultMinListRowHeight, 70)
        .toolbar {
            ToolbarItem(placement: .primaryAction) {
                settingsButton
            }
        }
        .sheet(isPresented: $isShowSettings) {
            AddPasswordView()
                .accentColor(.purple)
        }
        .empedInNavigation(title: "OTPHub")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
