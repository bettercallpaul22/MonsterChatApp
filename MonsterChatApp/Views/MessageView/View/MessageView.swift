import SwiftUI

struct MessageView: View {
    @State private var textFieldHeight: CGFloat = 40
    @Namespace var bottomID
    //    private let chat: Chat?
    let membersId_: [String]
    let chatRoomId_: String
    let username: String
    let chatId:String?
    
    @State var messageType: MessageType = .text
    @State var message: String = ""
    @State var captionMessage: String = ""
    @State var photo: UIImage? = nil
    @State var video: String? = nil
    @State var audio: String? = nil
    @State var location: String? = nil
    @State var audioDuration: Float? = nil
    
    @FocusState var inputFocus:Bool
    @State private var sendMediaSheet: Bool = false
    @State private var showImagePicker: Bool = false
    @StateObject private var messageViewModel: MessageViewModel = MessageViewModel()
    @StateObject private var chatViewModel: ChatViewModel = ChatViewModel()
    
    private func sendMessage() {
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
        NavigationStack {
            VStack {
                ScrollViewReader { proxy in
                    ScrollView {
                        ForEach(messageViewModel.realmMessages) { message in
                            HStack {
                                if message.senderId != User.currentUserId {
                                    if message.type == "text" {
                                        MessageCellViewlLeft(message: message, membersId: membersId_)
                                    } else if message.type == "photo" {
                                        PhotoMessageLeft(message: message)
                                        
                                    }
                                } else {
                                    if message.type == "text" {
                                        MessageCellViewRight(message: message, readStatus:messageViewModel.userMessageViewState == "inMessageView" ? true : false)
                                    } else if message.type == "photo" {
                                        PhotoMessageRight(message: message)
                                        
                                    }
                                }
                            }
                            .padding(.leading, 10)
                            .padding(.trailing, 10)
                            .padding(.vertical, 5)
                            .onAppear{
                                
                                messageViewModel.updateMessageReadStatus(message: message, membersId: membersId_)

                            }
                            
                            
                        }
                        EmptyView()
                            .id(bottomID)
                        Spacer()
                    }.contentShape(Rectangle())
                        .onTapGesture {
                            inputFocus = false
                            messageViewModel.updateTyping(typing: false, chatroomId: chatRoomId_)

                        }
                        .task{
                            proxy.scrollTo(bottomID)
                        }
                        .onChange(of: messageViewModel.lastMessageObj?.id, { oldvalue, newvalue  in
                            proxy.scrollTo(bottomID)
                            
                        })
                    
            
                    
                }
                Spacer()
                
                // Sending media
                if photo != nil {
                    HStack {
                        VStack(alignment: .trailing) {
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
                                    .onChange(of: message) { oldValue, newValue in
                                        let size = CGSize(width: UIScreen.main.bounds.width - 90, height: .infinity)
                                        let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                                        let estimatedSize = NSString(string: newValue).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                                        textFieldHeight = min(estimatedSize.height + 20, 200) // Limit to a max height of 200
                                    }
                                
                                Button(action: {
                                    messageType = .photo
                                    sendMessage()
                                    captionMessage = ""
                                    self.photo = nil
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
                    }
                    .padding()
                }
                if messageViewModel.isUserTyping{
                    Text("\(username) is typing...")
                        .font(.caption)
                    
                }
                if !messageViewModel.userMessageViewState.isEmpty{
                    Text(messageViewModel.userMessageViewState)
                        .font(.caption)
                    
                }
                
                
                if photo == nil {
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
                            .focused($inputFocus)
                            .onChange(of: inputFocus) {oldvalue, newValue in
                     
                            }

                        
                            .onChange(of: message) { oldValue, newValue in
                                if newValue.count > 0{
                                    messageViewModel.updateTyping(typing: true, chatroomId: chatRoomId_)
                                }else{
                                    messageViewModel.updateTyping(typing: false, chatroomId: chatRoomId_)
                                    
                                }
                                
                                let size = CGSize(width: UIScreen.main.bounds.width - 90, height: .infinity)
                                let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.systemFont(ofSize: 17)]
                                let estimatedSize = NSString(string: newValue).boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
                                textFieldHeight = min(estimatedSize.height + 20, 200) // Limit to a max height of 200
                            }
                        
                        Button(action: {
                            
                            messageType = .text
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
            }
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(Image: $photo)
            })
            .navigationTitle(username + messageViewModel.userMessageViewState)
            .navigationBarTitleDisplayMode(.inline)
            .task {
                chatViewModel.restartChat(chatRoomId: chatRoomId_, membersIds: membersId_)
                messageViewModel.getMessages(chatRoomId: chatRoomId_)
                messageViewModel.updateTyping(typing: false, chatroomId: chatRoomId_)
                
                
            }
            .onAppear{
                messageViewModel.typingListener(chatRoomId_)
                messageViewModel.messageViewListener(chatRoomId_)
                messageViewModel.updateMessageViewState(state: "inMessageView", chatRoomId: chatRoomId_)
//                print("chat id", chatId!)
            }
            .onDisappear {
                messageViewModel.updateMessageViewState(state: "online", chatRoomId: chatRoomId_)

            }
            
            
            
            
        }
    }
}

#Preview {
    NavigationStack {
        MessageView(membersId_: ["SjVfsykrQzbtNUrGaX4MTAZEJdw2", "SjVfsykrQzbtNUrGaX4MTAZEJdw2"], chatRoomId_: "SjVfsykrQzbtNUrGaX4MTAZEJdw2dlV1nIXmSibYEKhMVlz3TOQD5eN2", username: "", chatId: "123")
    }
}
