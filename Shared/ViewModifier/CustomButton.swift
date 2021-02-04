//
//  CustomButton.swift
//  OTPHub
//
//  Created by Дмитрий Лисин on 18.01.2021.
//

import SwiftUI

struct CustomButton: ButtonStyle {
    var backgroundColor: Color = .accentColor
    var labelColor: Color = .white
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Spacer()
            configuration.label
                .font(.system(.body, design: .rounded))
                .foregroundColor(labelColor)
            Spacer()
        }
        .padding()
        .background(backgroundColor)
        .cornerRadius(8)
        .shadow(radius: 6)
        .scaleEffect(configuration.isPressed ? 0.95 : 1)
    }
}
