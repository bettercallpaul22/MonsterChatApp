//
//  MessageCellViewlLeft.swift
//  MonsterChat
//
//  Created by Obaro Paul on 21/06/2024.
//

import SwiftUI
struct MessageCellViewlLeft: View {
    @StateObject private var messageViewModel: MessageViewModel = MessageViewModel()

    let message:RealmLocalMessage?
    let membersId:[String]
    func fDate(_ date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date)
    }
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            CircularImage(image: messageViewModel.avatar, size: .extraSmall)
            
        VStack(alignment: .leading) {

            Text(message?.message ?? "")
                .font(.system(size: 16))
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background(Color.purple.opacity(0.2))
//                    .cornerRadius(10)
                    .customConerRadius(24, corners: [.topRight, .topLeft, .bottomRight])

                
                
                HStack {
//                    if messageViewModel.isLoading{
//                        Image(systemName: "checkmark.circle")
//                    }else{
//                        ProgressView()
//                            .frame(width: 20, height: 20)
//                    }
                    Text(fDate(message!.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
           
            Spacer()
            
        }.onAppear {
            messageViewModel.getImage(membersId.filter{$0 != User.currentUserId}.first!, directory: .avatar)
           }
    }
}

#Preview {
    MessageCellViewlLeft(message: nil, membersId:["String"])
}
