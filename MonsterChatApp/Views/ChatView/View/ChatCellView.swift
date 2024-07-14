






//
//  UserCell.swift
//  MonsterChat
//
//  Created by Obaro Paul on 11/06/2024.
//

import SwiftUI

struct ChatCellView: View {
    @StateObject var userViewModel:UserViewModel = UserViewModel()
    
    @StateObject var chatViewModel:ChatViewModel = ChatViewModel()
    
    
    let chat:Chat
    @State private var lastMessageObject: LastMessage? = nil
    
    
    var body: some View {
        HStack(alignment:.top){
            VStack{
                CircularImage(image: chatViewModel.avatar, size: .small)
            }
            VStack{
                HStack(){
                    
                    Text(chat.receiverName)
                        .font(.headline)
                        .padding(.bottom, 2)
                    Spacer()
                    Text(chat.date!, format: .dateTime.hour().minute())
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                    
                }.padding(.leading, 10)
                
                HStack(){
                    Text(chat.lastMessage)
                        .font(.subheadline)
                        .foregroundStyle(Color(.systemGray))
                    Spacer()
                    ZStack{
                        Rectangle()
                            .fill(Color(.systemGreen))
                            .cornerRadius(20)
                            .frame(width: 25, height: 25)
                        Text("\(chat.unreadCounter)")
                            .font(.caption)
                            .bold()
                            .foregroundStyle(.white)
                    }
                    
                }.padding(.leading, 10)
            }
            
        }
        
        .onAppear(perform: {
            chatViewModel.setAvatar(avatarLink: chat.avatarLink, userId: chat.receiverId)
            self.lastMessageObject = LastMessage.getLastMessageObject(mlastMessageObject)
        })
        
    }
}

//#Preview {
//    ChatCellView(chat: Chat(id: "yyeuhej", chatRoomId: "jdhjdeh", senderId: "jdhjhheh", senderName: "obaro paul", receiverId: "98ueyhbe", receiverName: "blessing", date: Date(), memberId: ["0ihdw"], lastMessage: "hello dear", unreadCounter: 0, avatarLink: "ioudghbjdhds"))
//}




























