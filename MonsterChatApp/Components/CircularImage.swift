//
//  SwiftUIView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 07/06/2024.
//

import SwiftUI

struct CircularImage: View {
    let image:UIImage?
    let height:CGFloat
    let width:CGFloat
    @State private var currentUser: User? = User.currentUser

    var body: some View {
        Image(uiImage: image!)
            .resizable()
            .frame(width: width, height: height)
            .clipShape(Circle())
    }
}

#Preview {
    CircularImage(image: nil, height: 40, width: 40)
}
