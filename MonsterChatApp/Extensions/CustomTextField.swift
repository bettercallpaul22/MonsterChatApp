//
//  CustomTextField.swift
//  MonsterChat
//
//  Created by Obaro Paul on 24/06/2024.
//

import SwiftUI

struct CustomTextField: ViewModifier {
    var image:Image
    func body(content: Content) -> some View {
        content
            .padding(15)
            .padding(.leading, 36)
            .textInputAutocapitalization(.never)
            .mask(
                RoundedRectangle(cornerRadius: 10, style: .continuous)
                    
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10, style: .continuous).stroke()
            )
            .overlay(
                image
                    .frame(maxWidth: .infinity, alignment:.leading)
                    .padding(8)
            )
            .background(.white)
    }
}

extension View{
    func customTextField(image:Image = Image("Icon Email"))->some View{
        modifier(CustomTextField(image: image))
    }
}

