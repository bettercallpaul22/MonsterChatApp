import SwiftUI

struct MessageView: View {
    @State private var textFieldHeight: CGFloat = 40
    @Namespace var bottomID
    //    private let chat: Chat?
    let membersId_:[String]
    let chatRoomId_:String
    let username:String
    
    @State var messageType:MessageType = .text
    @State var message:String = ""
    @State var captionMessage:String = ""
    @State var photo:UIImage? = nil
    @State var video:String? = nil
    @State var audio:String? = nil
    @State var location:String? = nil
    @State var audioDuration:Float? = nil
    
    @State private var sendMediaSheet:Bool = false
    @State private var showImagePicker:Bool = false
    @StateObject private var messageViewModel: MessageViewModel = MessageViewModel()
    @StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
    
    
    private func sendMessage(){
        messageViewModel.senMessage(
            messageType: messageType,
            text: message,
            photo: photo,
            photoCaption: captionMessage,
            video: video,
            audio: audio,
            location: location,
            audioDuration: 0.0,
            membersId: membersId_,
            chatRoomId: chatRoomId_)
    }
    
    
    var body: some View {
        NavigationStack{
            VStack{
                ScrollViewReader { proxy in
                    ScrollView{
                        ForEach(messageViewModel.realmMessages){ message in
                            HStack{
                                if message.senderId != User.currentUserId{
                                    MessageCellViewlLeft(message: message)
                                    
                                }else{
                                    MessageCellViewRight(message: message)
                                    
                                }
                            } .onAppear {
                                withAnimation {
                                    proxy.scrollTo(bottomID)
                                }
                            }
                            
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.vertical, 5)
                            
                        }
                        EmptyView()
                            .id(bottomID)
                        Spacer()
                    }.onChange(of: messageViewModel.lastMessageObj?.id) { oldValue, newValue in
                        withAnimation {
                            proxy.scrollTo(bottomID)
                        }
                        
                        
                    }
                    
                    
                    
                }
                Spacer()
                
                // Sending media
                
                if photo != nil {
                    HStack{
                    
                        VStack(alignment:.trailing) {
                            Image(uiImage: photo!)
                                .resizable()
                                .scaledToFit()
                            .frame(width: 200, height: 140)
                            
                            HStack(alignment: .bottom) {
                                    
                                       
                                       TextField("Add a caption", text: $captionMessage, axis: .vertical)
                                           .padding(10)
                                           .background(Color(.systemGray6))
                                           .cornerRadius(10)
                                           .frame(height: max(textFieldHeight, 40))
                                           .onChange(of: message) { newValue in
                                               let size = CGSize(width: UIScreen.main.bounds.width - 90, height: .infinity)
                                               let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                                               let estimatedSize = NSString(string: newValue).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                                               textFieldHeight = min(estimatedSize.height + 20, 200) // Limit to a max height of 200
                                           }

                                       Button(action: {
                                           messageType = .photo
//                                           MessageType.photo.rawValue
                                           sendMessage()
                                           captionMessage = ""
                                           photo = nil
                                           textFieldHeight = 40
                                       }) {
                                           Image(systemName: "paperplane.fill")
                                               .foregroundColor(.white)
                                               .padding()
                                               .background(Color.fromHex("F77D8E"))
                                               .cornerRadius(10)
                                       }
                                       .padding(.leading, 10)
                                   }
                                   .padding(10)
                                   .background(Color(.systemGray5))
                                   .cornerRadius(20)
                                   .padding(10)
                                
                                
                        }
                    }.padding()
                       
                }
    
                if photo == nil  {
                    HStack(alignment: .bottom) {
                               Button(action: {
                                   self.showImagePicker = true
                               }) {
                                   Image(systemName: "plus.rectangle.on.rectangle.fill")
                                       .foregroundColor(.white)
                                       .padding(5)
                                       .background(Color.fromHex("F77D8E"))
                                       .cornerRadius(10)
                               }
                               
                               
                               TextField("Type a message...", text: $message, axis: .vertical)
                                   .padding(10)
                                   .background(Color(.systemGray6))
                                   .cornerRadius(10)
                                   .frame(height: max(textFieldHeight, 40))
                                   .onChange(of: message) { newValue in
                                       let size = CGSize(width: UIScreen.main.bounds.width - 90, height: .infinity)
                                       let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                                       let estimatedSize = NSString(string: newValue).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                                       textFieldHeight = min(estimatedSize.height + 20, 200) // Limit to a max height of 200
                                   }

                               Button(action: {
                                   messageType = .text
//                                   MessageType.text.rawValue
                                   sendMessage()
                                   message = ""
                                   textFieldHeight = 40
                               }) {
                                   Image(systemName: "paperplane.fill")
                                       .foregroundColor(.white)
                                       .padding()
                                       .background(Color.fromHex("F77D8E"))
                                       .cornerRadius(10)
                               }
                               .padding(.leading, 10)
                               .disabled(message.isEmpty)
                           }
                           .padding(10)
                           .background(Color(.systemGray5))
                           .cornerRadius(20)
                           .padding(10)
                }
                
//                if photo == nil {
//                    HStack{
//
//                        Button(action: {
//                            sendMediaSheet = true
//                        }, label: {
//                            Image(systemName: "plus.app")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 40, height: 40)
//                                .foregroundColor(.gray)
//
//                        }).actionSheet(isPresented: $sendMediaSheet) {
//                            ActionSheet(title: Text("Send Media"),
//
//                                        buttons: [
//                                            .cancel(),
//                                            .default(
//                                                Text("Camera"),
//                                                action: {
//                                                    self.showImagePicker = true
//
//                                                }
//                                            ),
//                                            .default(
//                                                Text("Gallery"),
//                                                action: {
//                                                    self.showImagePicker = true
//
//                                                }
//                                            ),
//
//                                                .default(
//                                                    Text("Send Location"),
//                                                    action: {}
//                                                )
//                                        ]
//                            )
//                        }
//
//                        TextField("Say something!", text: $message, axis: .vertical)
//                            .padding()
//                            .background(
//                                RoundedRectangle(cornerRadius: 10)
//                                    .fill(Color(.systemGray6))
//                            )
//
//                        Button(action: {
//                            sendMessage()
//                            message = ""
//                        }, label: {
//                            Image(systemName: message.isEmpty ? "mic.fill" : "paperplane.circle.fill")
//                                .resizable()
//                                .scaledToFit()
//                                .frame(width: 40, height: 40)
//                                .foregroundColor(.gray)
//
//
//                        })
//
//
//                    }.padding()
//                }
            }
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(Image: $photo)
            })
            .navigationTitle(username)
            .onAppear(perform: {
                chatViewModel.restartChat(chatRoomId: chatRoomId_, membersIds: membersId_)
                //                    messageViewModel.observeRealm(chatRoomId: chatRoomId_)
                messageViewModel.getMessages(chatRoomId: chatRoomId_)
                
            })
        }
    }
}

#Preview {
    NavigationStack{
        MessageView(membersId_: ["SjVfsykrQzbtNUrGaX4MTAZEJdw2", "SjVfsykrQzbtNUrGaX4MTAZEJdw2"], chatRoomId_: "SjVfsykrQzbtNUrGaX4MTAZEJdw2dlV1nIXmSibYEKhMVlz3TOQD5eN2", username: "")
        
    }
}
