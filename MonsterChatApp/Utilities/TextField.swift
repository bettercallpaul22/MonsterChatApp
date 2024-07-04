//
//  TextField.swift
//  MonsterChat
//
//  Created by Obaro Paul on 05/06/2024.
//

import Foundation

//
//  Created by Obaro Paul on 04/06/2024.
//

import SwiftUI

struct FloatingPlaceholderTextFieldStyle: TextFieldStyle {
    @Binding var text: String
    let placeholder: String
    
    func _body(configuration: TextField<Self._Label>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(placeholder)
                .foregroundColor(.gray)
                .offset(y: text.isEmpty ? 0 : -24)
                .scaleEffect(text.isEmpty ? 1 : 0.8, anchor: .leading)
                .animation(.easeInOut(duration: 0.2), value: text.isEmpty)
            
            configuration
                .autocapitalization(.none) // Disable auto-capitalization
                .padding(.bottom, 2)
                .background(Rectangle().frame(height: 2).foregroundColor(Color.gray), alignment: .bottom)
        }
    }
}
