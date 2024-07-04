//
//  MessageCellViewlLeft.swift
//  MonsterChat
//
//  Created by Obaro Paul on 21/06/2024.
//

import SwiftUI
struct MessageCellViewlLeft: View {
    let message:RealmLocalMessage?
    func fDate(_ date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date)
    }
    var body: some View {
        HStack(alignment: .bottom, spacing: 10) {
            Image("profile")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
        VStack(alignment: .leading) {

            Text(message?.message ?? "")
                .font(.system(size: 16))
                    .padding(5)
                    .padding(.horizontal, 5)
                    .background(Color.purple.opacity(0.2))
//                    .cornerRadius(10)
                    .customConerRadius(24, corners: [.topRight, .topLeft, .bottomRight])

                
                
                HStack {
                    Image(systemName: "checkmark.circle")
                    Text(fDate(message!.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                }
            }
           
            Spacer()
            
        }
    }
}

#Preview {
    MessageCellViewlLeft(message: nil)
}
