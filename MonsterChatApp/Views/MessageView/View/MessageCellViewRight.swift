//
//  SwiftUIView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 21/06/2024.
//

import SwiftUI

struct MessageCellViewRight: View {
    let message:RealmLocalMessage?
    func fDate(_ date:Date) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mma"
        return formatter.string(from: date)
    }
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
                    Text(fDate(message!.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Image(systemName: "checkmark.circle")
                }
            }
            Image("profile")
                .resizable()
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            
        }
    }
}

#Preview {
    MessageCellViewRight(message: nil)
}
