//
//  CustomButton.swift
//  MonsterChatApp
//
//  Created by Obaro Paul on 06/07/2024.
//

import SwiftUI

struct CustomButton: View {
    let loadingState: Bool
    let title: String
    let action: () -> Void
    
    var body: some View {
        HStack {
            Button(action: action) {
                Text(loadingState ? "Please wait..." : title)
                    .padding(20)
                    .fontWeight(.heavy)
                    .frame(maxWidth: .infinity)
                    .foregroundColor(.white)
                    .background(Color.fromHex("F77D8E"))
            }
            .disabled(loadingState)
        }
        .customConerRadius(20, corners: [.allCorners])
        .padding(.vertical, 20)
        .shadow(color: Color.fromHex("F77D8E").opacity(0.4), radius: 20, x: 0, y: 10)
    }
}

#Preview {
    CustomButton(loadingState: false, title: "Save", action: {
        print("Button pressed")
    })
}
