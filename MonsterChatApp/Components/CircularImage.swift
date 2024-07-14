//
//  SwiftUIView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 07/06/2024.
//

import SwiftUI

struct CircularImage: View {
    let image:UIImage?
    let size: ImageSizes
    enum ImageSizes{
        case extraSmall
        case small
        case mediuim
        case large
        
    }
    @State private var currentUser: User? = User.currentUser

    var body: some View {
       
        switch size {
        case .small:
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 40, height: 40)
                    .clipShape(Circle())
            }
        case .mediuim:
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
            }
        case .large:
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 120, height: 120)
                    .clipShape(Circle())
            }
        case .extraSmall:
            if let image = image {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }else{
                Image(systemName: "person.circle.fill")
                    .resizable()
                    .frame(width: 32, height: 32)
                    .clipShape(Circle())
            }
        }
        
           
    }
}

//#Preview {
//    CircularImage(image: nil, height: 40, width: 40)
//}
