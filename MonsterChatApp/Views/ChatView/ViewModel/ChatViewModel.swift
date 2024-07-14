import Foundation
import Firebase
import Combine
import SwiftUI

class ChatViewModel:ObservableObject {
    @Published var chats:[Chat] = []
    @Published var avatar:UIImage? = nil
    @Published  var isLoading:Bool = false
    @Published var userMessageViewState:String = ""

    
    var cancellables = Set<AnyCancellable>()
    
    
    init(){
  
    }
    
    
    func setAvatar(avatarLink: String, userId: String) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){ [self] in
            
            if !userId.isEmpty || !avatarLink.isEmpty{
                                LocalFileManager.instance.readAnWriteImage(fileName:userId, firebaseImageUrlPath: .avatar)
                    .sink { completion in
                        switch completion{
                        case.failure(let error):
                            print("userViewModel getting image error : ", error.localizedDescription)
                        case .finished:
                            break
                        }
                    } receiveValue: { [weak self] image in
                        self?.avatar = image
                    }.store(in: &cancellables)

                
            }
        }
        
    }
    
    
    func getChats (){ 
//        print("getting chats....")
        guard User.currentUser != nil else{
            return
        }
        self.isLoading = true
        FirebaseChatReference.instance.getChats()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.isLoading = false
                    break
                case .failure(let error):
                    self.isLoading = false
                    print("Failed to get chats:", error.localizedDescription)
                }
            }, receiveValue: { [weak self] receivedChats in
                var fChat:[Chat] = []
                fChat =  receivedChats.filter{ $0.lastMessage != ""}
                fChat.sort(by: { $0.date! > $1.date! })

                self?.chats = fChat
//                if let lastMessage = messages.last {
//                    let message = LastMessage(date:lastMessage.sentDate, lastMessage: lastMessage.message)
//                    LastMessage.setLastMessageObject(value: message, key: mlastMessageObject)
//
//                }

//                LastMessage.setLastMessageObject(value: <#T##LastMessage#>, key: <#T##String#>)
//                print("getsChat last message object\(String(describing: self!.chats.last))")
                self?.isLoading = false
            })
            .store(in: &cancellables)
    }
    
    
    func updateChatViewState(state:String, chatRoomId:String){
        FirebaseMessageReference.instance.updateMessageViewState(isOnViewState: state, chatroomId: chatRoomId)
    }
    
    func messageViewListener(_ chatRoomId:String){
        FirebaseMessageReference.instance.messageViewListener(chatRoomId)
            .sink { completion in
                switch completion{
                
                case .finished:
                   break
                case .failure(let error):
                    print("error listening to user messageview state", error)
                }
            } receiveValue: { [weak self] val in
//                self?.userMessageViewState = val
            }.store(in: &cancellables)

    }
    
    
    
    func startChat(user1: User, user2: User) -> String {
        let chatRoomId = getChatRoomID(userID_1: user1.id, userID_2: user2.id)
        
        // Create recent items for the users in the chat
        createRecentItems(chatRoomId: chatRoomId, users: [user1, user2])
        
        return chatRoomId
    }
    
    // incase a user deleted their chat,thsi will create a new chat for the other user
    func restartChat(chatRoomId:String, membersIds:[String]){
        FirebaseUserReference.instance.getUsers(withIds: membersIds)
            .sink { completion in
                switch completion{
                case.failure(let error):
                    print(error.localizedDescription)
                case .finished:
                    print("success getiing user/users")
                }
            } receiveValue: { [weak self] userArr in
                self?.createRecentItems(chatRoomId: chatRoomId, users: userArr)
            }.store(in: &cancellables)

    }
    
    
    func createRecentItems(chatRoomId: String, users: [User]) {
        var memberIdsToCreateRecent = [users.first!.id, users.last!.id]
        // Check if any user already has recent chats for this chat room
        FirebaseUserReference.instance.firebaseRefrence(.Recent)
            .whereField("chatRoomId", isEqualTo: chatRoomId)
            .getDocuments { querySnapshot, error in
                if let error = error {
                    print("Error fetching snapshot: \(error.localizedDescription)")
                    return
                }
                
                guard let snapshot = querySnapshot else { return }
                
                if !snapshot.isEmpty {
                    memberIdsToCreateRecent = self.filterMembersWithExistingRecent(snapshot: snapshot, memberIds: memberIdsToCreateRecent)
                }
                
                // Create recent items for each member
                for userId in memberIdsToCreateRecent {
                    //                    let senderUser = userId == User.currentUserId ? User.currentUser! : self.getReceiverFrom(users: users)
                    //                    let receiverUser = userId == User.currentUserId ? self.getReceiverFrom(users: users) : User.currentUser!
                    let (senderUser, receiverUser) = self.getUsersForChat(userId: userId, users: users)
                    
                    
                    let chat = Chat(
                        id: UUID().uuidString, // Use UUID() directly to get a new UUID string
                        chatRoomId: chatRoomId,
                        senderId: senderUser.id,
                        senderName: senderUser.username,
                        receiverId: receiverUser.id,
                        receiverName: receiverUser.username,
                        date: Date(),
                        memberId: [senderUser.id, receiverUser.id],
                        lastMessage: "",
                        unreadCounter: 0,
                        avatarLink: receiverUser.avatarLink
                    )
                    
                    // Here you might want to save `recentObject` to Firebase or handle it accordingly
                    FirebaseChatReference.instance.addChat(chat)
                }
            }
    }
    
    /// Removes members who already have a recent chat item for the given chat room ID.
    ///
    /// - Parameters:
    ///   - snapshot: The snapshot of existing recent chat items.
    ///   - memberIds: The list of member IDs to check and potentially remove.
    /// - Returns: The updated list of member IDs after removing those with existing recent items.
    func filterMembersWithExistingRecent(snapshot: QuerySnapshot, memberIds: [String]) -> [String] {
        var filteredMemberIds = memberIds
        
        // Loop through each document in the snapshot (snapshot.documents is a list of documents from Firebase)
        for document in snapshot.documents {
            
            // Get the data from the document (each document is like a dictionary with key-value pairs)
            if let existingUserId = document.data()[mSenderId] as? String {
                filteredMemberIds.removeAll { $0 == existingUserId }
            }
        }
        
        // returns an array of strings that does not include any two of that membersId
        return filteredMemberIds
        
    }
    
    // MARK: - Helper Methods
    
    /// Generates a chat room ID using two user IDs.
    ///
    /// - Parameters:
    ///   - userID_1: The ID of the first user.
    ///   - userID_2: The ID of the second user.
    /// - Returns: The generated chat room ID.
    func getChatRoomID(userID_1: String, userID_2: String) -> String {
        let chatRoomId = userID_1 < userID_2 ? "\(userID_1)\(userID_2)" : "\(userID_2)\(userID_1)"
        return chatRoomId
    }
    

    func getUsersForChat(userId: String, users: [User]) -> (senderUser: User, receiverUser: User) {
        // This code runs twice because it is in a "For Loop" that iterate twice
        // At first the id will be the CurrentUserId
        // At second run the id will be the other user id
        
        if userId == User.currentUserId {
            let receiverUser = getReceiverFrom(users: users)
            return (senderUser: User.currentUser!, receiverUser: receiverUser)
        } else {
            let receiverUser = User.currentUser!
            let senderUser = getReceiverFrom(users: users) // sender this time will me th user which is not me
            return (senderUser: senderUser, receiverUser: receiverUser)
        }
    }
    
    // Function to get a receiver from the list of users excluding the current user
    func getReceiverFrom(users: [User]) -> User {
        return users.filter{ $0.id != User.currentUserId }.first!
    }
    
    func deleteChat(chat:Chat){
        FirebaseChatReference.instance.deleteChat(chat: chat)
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion{
                case .failure(let error):
                    print("delete error: ",error.localizedDescription)
                case .finished:
                    print("chat deleted success")
                }
            } receiveValue: { value in
                print("delete value", value)
            }  .store(in: &cancellables)
        
    }
    
    
}


