import SwiftUI

struct ChatView: View {
    @StateObject var userViewModel: UserViewModel = UserViewModel()
    @StateObject var chatViewModel: ChatViewModel = ChatViewModel()
    @State private var searchText: String = ""
    
    @State private var userChat: Chat? = nil
    
    func deleteItems(at offsets: IndexSet) {
        if userChat == nil {
            print("user chat is nil", userChat as Any)
            return
        }else{
            chatViewModel.deleteChat(chat: userChat!)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0, execute: {
            chatViewModel.chats.remove(atOffsets: offsets)
        })
        
        // Update the userChat variable
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
               
                SearchField(searchText: $searchText)
                List {
                    Section {
                        if userViewModel.isLoading {
                            ProgressView()
                        } else {
                            ForEach(chatViewModel.chats) { chat in
                                NavigationLink(destination: MessageView(membersId_: chat.memberId, chatRoomId_: chat.chatRoomId, username: chat.receiverName, chatId: chat.id).toolbar(.hidden, for: .tabBar)) {
                                    ChatCellView(chat: chat)
                                        .onAppear{
                                            
                                            chatViewModel.messageViewListener(chat.chatRoomId)

                                            chatViewModel.updateChatViewState(state: "online", chatRoomId: chat.chatRoomId)

                                        }
                                       
                                }
                            }
                            .onDelete { indexSet in
                                // Get the chat item to be deleted
                                if let index = indexSet.first {
                                    let chat = chatViewModel.chats[index]
                                    userChat = chat
                                    
                                    deleteItems(at: indexSet)
                                }
                            }
                        }
                    }
//                    .padding()
                }
            }.navigationBarBackButtonHidden()

            
            .background(Color(.systemGray5))
            .navigationTitle("Recent Chat")
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    
                    NavigationLink(destination: UsersView()) {
                        Image(systemName: "person.3.fill")
                            .foregroundColor(.gray)
                    }
                    
                    
                }
            }
            .onAppear {                
                chatViewModel.getChats()
            }
        }
   
    }
}

#Preview {
    NavigationStack {
        ChatView()
    }
}
