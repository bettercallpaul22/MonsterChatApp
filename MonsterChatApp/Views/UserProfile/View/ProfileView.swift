//
//  ProfileView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 13/06/2024.
//

import SwiftUI

struct ProfileView: View {
    @StateObject var userViewModel:UserViewModel = UserViewModel()
    @StateObject var chatViewModel:ChatViewModel = ChatViewModel()
    
    let user:User
    let avatar:UIImage?
    //    let chatRoomId:Str = ""
    
    
    var body: some View {
        Form{
            VStack{
                HStack{
                    if userViewModel.avatar != nil{
                        Image(uiImage: userViewModel.avatar!)
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 5)
                    }else{
                        Image("userimage")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 100, height: 100)
                            .clipShape(Circle())
                            .overlay(Circle().stroke(Color.white, lineWidth: 4))
                            .shadow(radius: 5)
                        
                    }
                    
                }
                Text(user.username)
                    .font(.title2)
                    .bold()
                Text(user.status)
                    .font(.title3)
                    .foregroundStyle(Color(.systemGray))
            }
            .toolbar(.hidden, for: .tabBar)
            .frame(minWidth: 300)
            .padding()
            
            .background(.white)
            
            NavigationLink(
                destination:
                    MessageView(
                        membersId_: [user.id, User.currentUserId! as String],
                        chatRoomId_: chatViewModel.getChatRoomID(userID_1: user.id, userID_2:User.currentUserId! as String), username: user.username, chatId: nil)) {
                            HStack{
                                Text("Start Chat")
                                Image(systemName: "ellipsis.message.fill")
                            }
                        }
            
        }.navigationTitle("Profile")
            .onAppear {
                userViewModel.configureUser(user: user)
                
            }
    }
    
    
    
    
}

#Preview {
    NavigationStack{
        ProfileView(user: User.dummyUser, avatar: UIImage(named: "userimage"))
    }
}
