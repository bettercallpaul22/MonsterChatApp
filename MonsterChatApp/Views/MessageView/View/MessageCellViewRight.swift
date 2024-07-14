//
//  SwiftUIView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 21/06/2024.
//

import SwiftUI

struct MessageCellViewRight: View {
      
     
    let message:RealmLocalMessage?
    let readStatus:Bool
    @StateObject private var messageViewModel: MessageViewModel = MessageViewModel()

   
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Spacer()
            VStack(alignment: .trailing) {

                Text(message?.message ?? "")
                    .font(.system(size: 16))
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background(Color.blue.opacity(0.2))
                    .customConerRadius(24, corners: [.topRight, .topLeft, .bottomLeft])

                
                
                HStack {
                    Text(customFormatter.fDate(message!.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    if messageViewModel.isLoading{
                        ProgressView()
                            .frame(width: 20, height: 20)
                    }else{
                        Text(message!.status)
                            .font(.caption)
                            .foregroundColor(Color(.systemGray))
//                        Image(systemName: "checkmark.circle")
//                            .background(readStatus ? .green : .clear)
//                            .clipShape(Circle())
                    }
                    
                }
            }
            CircularImage(image: messageViewModel.avatar, size: .extraSmall)

           
            
        }.onAppear(perform: {
            
            if let senderId = message?.senderId{
                messageViewModel.getImage(senderId,directory: .avatar)

            }
        })
    }
}

#Preview {
    MessageCellViewRight(message: nil, readStatus: false)
}
