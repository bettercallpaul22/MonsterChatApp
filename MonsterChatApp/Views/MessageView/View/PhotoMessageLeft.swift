import SwiftUI

struct PhotoMessageLeft: View {
    @StateObject var messageViewModel: MessageViewModel = MessageViewModel()
    let message: RealmLocalMessage
    let senderType: SenderType
    
    var body: some View {
        
        
        HStack(alignment:.top){
            CircularImage(image: messageViewModel.avatar, size: .extraSmall)
            VStack(alignment:.trailing){
            ZStack {
                
                VStack(alignment: .leading) {
                    HStack {
                        if let image = messageViewModel.avatar {
                            Image(uiImage: image)
                                .resizable()
                                .scaledToFit()
                                .customConerRadius(10, corners: [ .topLeft])
                                .overlay {
                                    if messageViewModel.isLoading{
                                        ProgressView()
                                    }
                                }
                            
                        } else {
                            Image(systemName: "person.circle.fill")
                                .resizable()
                                .scaledToFit()
                                .customConerRadius(10, corners: [ .topLeft])
                            //                            .background(Color.blue.opacity(0.2))
                            
                            
                        }
                    }
                    .frame(maxWidth: .infinity)
                    
                    Text(message.photoCaption)
                        .font(.caption)
                }
                
            }
            .frame(maxWidth: 200)
            .padding(4)
            .background(Color.fromHex(senderType == .receiver ? "F77D8E": "89CFF0").opacity(0.5))
            //        .customConerRadius(24, corners: [ .topLeft])
            .customConerRadius(3, corners: [ .bottomLeft, .bottomRight])
            .onAppear {
                messageViewModel.getImage("\(message.messageId)_\(message.senderId)", directory: .photoMessage)
                messageViewModel.getImage(message.senderId, directory: .avatar)
                
            }
                Text(customFormatter.fDate(message.date))
                    .font(.caption)
                    .foregroundColor(.gray)
                Image(systemName: "checkmark.circle")

        }
            
            Spacer()
            
        }.frame(maxWidth: .infinity)
          
        
        
    }
}

