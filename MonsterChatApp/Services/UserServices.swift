
import Foundation
import Firebase
import FirebaseFirestoreSwift
import Combine

class UserServices: ObservableObject{
    
    static let shared = UserServices()
    @Published var currentUser:User?
    static var instance = FirebaseUserReference()
    private var cancellables = Set<AnyCancellable>()
    
     func firebaseRefrence(_ collectionRefrence:FireBaseRefEnum) -> CollectionReference{
       return Firestore.firestore().collection(collectionRefrence.rawValue)
   }
    
    
    
    init(){
        Task{try await fetchCurrentUser()}
    }
    
    private func getCurrentUserId()->String{
        if let userId = Auth.auth().currentUser?.uid {
            return userId
        }else{
            print("No user found")
            return ""
        }
        
        
    }
    
    // Get a user by id
    @MainActor
    func fetchCurrentUser() async throws {
        guard let userId = Auth.auth().currentUser?.uid else {return} // get current logged in
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        let user =  try snapshot.data(as: User.self)
        self.currentUser = user
    }
    
    // Get all existing users excluding the current user
    static func getAllUsers() async throws -> [User] {
        guard let userId = Auth.auth().currentUser?.uid else {return [] } // get current logged in user, if none return.
        let snapshot = try await Firestore.firestore().collection("users").getDocuments()
        let allUsersDocuments = snapshot.documents.compactMap({ try? $0.data(as :User.self)})
        return allUsersDocuments.filter({$0.id != userId })
    }
    
    func reset(){
        self.currentUser = nil
    }
    
    
    // Update current user profile
    @MainActor
    func updateUserProfileImage(imageUrl:String) async throws {
        let userId = getCurrentUserId()
        try await Firestore.firestore().collection("users").document(userId).updateData([
            "profileImageUrl":imageUrl
        ])
//        self.currentUser?.profileImageUrl = imageUrl
    }
    
    
    // Fetch user
    static func fetchUser(userId:String)async throws -> User{
        let snapshot = try await Firestore.firestore().collection("users").document(userId).getDocument()
        
        let user =  try snapshot.data(as: User.self)
        return user
    }
    
    
}
