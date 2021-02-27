//
//  SettingsView.swift
//  OTPHub (iOS)
//
//  Created by Дмитрий Лисин on 18.02.2021.
//

import SwiftUI
import UniformTypeIdentifiers

struct SettingsView: View {
    @Environment(\.presentationMode) private var presentationMode

    @EnvironmentObject private var appStore: AppStore

    @State private var isExporting: Bool = false
    @State private var isImporting: Bool = false

    var appVersion: Text {
        let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as! String
        let build = Bundle.main.infoDictionary?["CFBundleVersion"] as! String
        return Text("section_footer_app_version \(version) (\(build))")
    }

    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }

    private func exporting() {
        isExporting = true
    }

    private func importing() {
        isImporting = true
    }

    var body: some View {
        NavigationView {
            Form {
                Section {
                    Button(action: exporting) {
                        Label("Резервное копирование", systemImage: "externaldrive.badge.timemachine")
                    }
                    Button(action: importing) {
                        Label("Восстановление", systemImage: "internaldrive")
                    }
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
            .fileExporter(
                isPresented: $isExporting,
                document: AccountDocument(account: appStore.accounts),
                contentType: UTType("com.darkfox.otphub.backup")!,
                defaultFilename: "Backup"
            ) { result in
                switch result {
                case let .success(url):
                    print(url)
                case let .failure(error):
                    print(error)
                }
            }
            .fileImporter(
                isPresented: $isImporting,
                allowedContentTypes: [UTType("com.darkfox.otphub.backup")!],
                allowsMultipleSelection: false
            ) { result in
                switch result {
                case let .success(url):
                    appStore.importAccountInKeychain(url.first)
                case let .failure(error):
                    print(error)
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
