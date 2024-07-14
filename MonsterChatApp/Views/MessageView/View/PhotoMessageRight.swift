import SwiftUI

struct PhotoMessageRight: View {
    @StateObject var messageViewModel: MessageViewModel = MessageViewModel()
    @StateObject var userService: UserService = UserService()

    let message: RealmLocalMessage
    
    var body: some View {
        
        
        HStack(alignment:.top){
            Spacer()

            VStack(alignment:.leading){
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
                            Image(systemName: "photo")
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
            .background(Color.fromHex("F77D8E").opacity(0.5))
            //        .customConerRadius(24, corners: [ .topLeft])
            .customConerRadius(3, corners: [ .bottomLeft, .bottomRight])
            
                HStack{
                    Text(customFormatter.fDate(message.date))
                        .font(.caption)
                        .foregroundColor(.gray)
                    Image(systemName: "checkmark.circle")
                }
        }
            
            CircularImage(image: userService.avatar, size: .extraSmall)

        }.frame(maxWidth: .infinity)
            .onAppear {
                messageViewModel.getImage("\(message.messageId)_\(message.senderId)", directory: .photoMessage)
                userService.getAvatar(message.senderId, directory: .avatar)

            }
          
        
        
    }
}

