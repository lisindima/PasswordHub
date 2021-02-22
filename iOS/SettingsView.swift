//
//  SettingsView.swift
//  OTPHub (iOS)
//
//  Created by Дмитрий Лисин on 18.02.2021.
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode
    
    @EnvironmentObject private var appStore: AppStore
    
    var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("section_footer_app_version \(version) (\(build))")
    }
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    private func test() {
        let account = try? appStore.loadAccountsFromKeychain()
        print(account!)
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: test) {
                        Label("Резервное копирование", systemImage: "externaldrive.badge.timemachine")
                    }
                    .buttonStyle(PlainButtonStyle())
                    Button(action: {}) {
                        Label("Восстановление", systemImage: "internaldrive")
                    }
                    .buttonStyle(PlainButtonStyle())
                }
                Section(footer: appVersion) {
                    NavigationLink(destination: License()) {
                        Label("navigation_link_license", systemImage: "doc.plaintext")
                    }
                }
            }
            .navigationTitle("navigation_title_settings")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button(action: dismissView) {
                        Label("close_toolbar", systemImage: "xmark")
                    }
                    .keyboardShortcut(.cancelAction)
                }
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
