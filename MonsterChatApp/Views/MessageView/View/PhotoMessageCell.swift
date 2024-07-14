//
//  PhotoMessageCell.swift
//  MonsterChatApp
//
//  Created by Obaro Paul on 06/07/2024.
//

import SwiftUI


struct PhotoMessageCell: View {
    let message: RealmLocalMessage
    let senderType: SenderType
    var body: some View {
        if senderType == .receiver{
           PhotoMessageLeft(message: message)
        }else{
            PhotoMessageRight(message: message)

        }
    }
}

//#Preview {
//    PhotoMessageCell()
//}
