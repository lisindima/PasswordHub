//
//  AddPasswordView.swift
//  OTPHub
//
//  Created by Дмитрий Лисин on 18.01.2021.
//

import SwiftUI

struct AddPasswordView: View {
    @Environment(\.managedObjectContext) private var moc
    @Environment(\.presentationMode) private var presentationMode
    
    @State private var passwordName: String = ""
    @State private var passwordSecret: String = ""
    @State private var updateTime: UpdateTime = .thirtySeconds
    @State private var sizePassword: SizePassword = .sixDigit
    @State private var passwordAlgorithm: PasswordAlgorithm = .sha1
    @State private var typeAlgorithm: TypeAlgorithm = .totp
    @State private var passwordColor: Color = .purple
    @State private var isShowAlert: Bool = false
    @State private var isShowQRView: Bool = false
    
    private func savePassword() {
        if passwordName.isEmpty || passwordSecret.isEmpty {
            isShowAlert = true
        } else {
            let hexString = passwordColor.hexStringFromColor()
            let item = Item(context: moc)
            item.passwordName = passwordName
            item.passwordSecret = passwordSecret
            item.passwordAlgorithm = passwordAlgorithm.rawValue
            item.typeAlgorithm = typeAlgorithm.rawValue
            item.updateTime = updateTime.rawValue
            item.sizePassword = sizePassword.rawValue
            item.passwordColor = hexString
            do {
                try moc.save()
                presentationMode.wrappedValue.dismiss()
            } catch {
                let nsError = error as NSError
                print("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func showQRView() {
        isShowQRView = true
    }
    
    private func dismissView() {
        presentationMode.wrappedValue.dismiss()
    }
    
    var body: some View {
        #if os(iOS)
        NavigationView {
            form
                .sheet(isPresented: $isShowQRView) {
                    QRView(
                        passwordName: $passwordName,
                        passwordSecret: $passwordSecret,
                        updateTime: $updateTime,
                        sizePassword: $sizePassword,
                        passwordAlgorithm: $passwordAlgorithm,
                        typeAlgorithm: $typeAlgorithm
                    )
                    .accentColor(.purple)
                }
        }
        #else
        form
            .padding()
        #endif
    }
    
    var form: some View {
        VStack {
            Form {
                Section(header: Text("section_header_basic_information")) {
                    TextField("textfield_name", text: $passwordName)
                    TextField("textfield_secret", text: $passwordSecret)
                }
                .customTextField()
                Section(
                    header: Text("section_header_password_length"),
                    footer: Text("section_footer_password_length")
                ) {
                    Picker("section_header_password_length", selection: $sizePassword) {
                        ForEach(SizePassword.allCases) { size in
                            Text(size.localized)
                                .tag(size)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                Section(
                    header: Text("section_header_update_time"),
                    footer: Text("section_footer_update_time")
                ) {
                    Picker("section_header_update_time", selection: $updateTime) {
                        ForEach(UpdateTime.allCases) { time in
                            Text(time.localized)
                                .tag(time)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                Section(
                    header: Text("section_header_encryption_type"),
                    footer: Text("section_footer_encryption_type")
                ) {
                    Picker("section_header_encryption_type", selection: $passwordAlgorithm) {
                        ForEach(PasswordAlgorithm.allCases) { algorithm in
                            Text(algorithm.rawValue)
                                .tag(algorithm)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .labelsHidden()
                }
                Section(
                    header: Text("section_header_customization"),
                    footer: Text("section_footer_customization")
                ) {
                    ColorPicker("colorpicker_title", selection: $passwordColor)
                        .colorPickerMac()
                }
            }
            #if os(iOS)
            HStack {
                Button(action: showQRView) {
                    Image(systemName: "qrcode")
                        .imageScale(.large)
                }
                .buttonStyle(
                    CustomButton(
                        backgroundColor: .accentColor.opacity(0.2),
                        labelColor: .accentColor
                    )
                )
                .frame(width: 80)
                Button("button_title_add_account", action: savePassword)
                    .buttonStyle(CustomButton())
            }
            .padding()
            #endif
        }
        .navigationTitle("navigation_title_new_account")
        .alert(isPresented: $isShowAlert) {
            Alert(
                title: Text("alert_error_title"),
                message: Text("alert_error_message"),
                dismissButton: .cancel()
            )
        }
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Picker("", selection: $typeAlgorithm) {
                    ForEach(TypeAlgorithm.allCases) { type in
                        Text(type.rawValue)
                            .tag(type)
                    }
                }
                .labelsHidden()
            }
            ToolbarItem(placement: .cancellationAction) {
                Button(action: dismissView) {
                    Label("close_toolbar", systemImage: "xmark")
                        .labelStyle(CustomLabelStyle())
                }
                .keyboardShortcut(.cancelAction)
            }
            #if os(macOS)
            ToolbarItem(placement: .confirmationAction) {
                Button("button_title_add_account", action: savePassword)
                    .keyboardShortcut(.defaultAction)
            }
            #endif
        }
    }
}
