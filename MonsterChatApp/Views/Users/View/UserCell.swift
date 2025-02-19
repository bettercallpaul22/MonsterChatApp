//
//  UserCell.swift
//  MonsterChat
//
//  Created by Obaro Paul on 11/06/2024.
//

import SwiftUI

struct UserCell: View {
    @StateObject var userViewModel:UserViewModel = UserViewModel()
    let user:User
    var body: some View {
        HStack(alignment:.top){
            VStack{
                CircularImage(image: userViewModel.avatar, size: .small)

            }
            VStack(alignment:.leading){
                Text(user.username)
                    .font(.headline)
                    .padding(.bottom, 2)
                Text(user.status)
                    .font(.subheadline)
                    .foregroundStyle(Color(.systemGray))
            }.padding(.leading, 10)
            
            Spacer()
        }
        .onAppear(perform: {
            userViewModel.configureUser(user: user)
        })
        .padding(10)
        .background(.white)
        .cornerRadius(10) // Adding corner radius to smooth the edges
        .shadow(color: .gray, radius: 5, x: 0, y: 2) // Adding shadow for better appearance
        .overlay(alignment: .trailing) {
            Image(systemName: "arrow.forward")
                .padding(.trailing, 10)
            
        }
        
    }
}

#Preview {
    NavigationStack{
        UserCell(user: User.dummyUser)
    }
}
