//
//  BackButton.swift
//  MonsterChat
//
//  Created by Obaro Paul on 07/06/2024.
//

import Foundation
import SwiftUI

extension View {
    func addBackButton(removeLast:Bool) -> some View {
        self.toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    if removeLast{
                        NavigationManager.shared.path.removeLast()

                    }
                }) {
                    Image(systemName: "chevron.left.circle.fill")
                        .foregroundColor(.black)
                }
            }
        }
    }
}
