//
//  FirebaseService.swift
//  MonsterChat
//
//  Created by Obaro Paul on 12/06/2024.
//

import Foundation
import FirebaseFirestore
import Firebase
import FirebaseStorage
import Combine

class FirebaseUserReference {
    static var instance = FirebaseUserReference()
    private var cancellables = Set<AnyCancellable>()
    
     func firebaseRefrence(_ collectionRefrence:FireBaseRefEnum) -> CollectionReference{
       return Firestore.firestore().collection(collectionRefrence.rawValue)
   }
   
    
    // fetch all users in the Users collection
    func fetchUsers() -> AnyPublisher<[User], Error> {
        Future<[User], Error> { promise in
                
            self.firebaseRefrence(.User).getDocuments { snapshot, error in
                    if let error = error {
                        promise(.failure(error))
                    } else {
                        let users = snapshot?.documents.compactMap { document -> User? in
                            
                            try? document.data(as: User.self)
                        } ?? []
                        let filteredUser = users.filter{$0.id != User.currentUserId  }
                        promise(.success(filteredUser))
//                        print("users firebase service  :\(users)")
                        
                    }
                }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    // get user
  
    func getUsers(withIds userIds: [String]) -> AnyPublisher<[User], Error> {

        let userPublishers = userIds.map { userId in
            Future<User, Error> { promise in
                let userRef = self.firebaseRefrence(.User).document(userId)
                
                userRef.getDocument { (document, error) in
                    if let error = error {
                        promise(.failure(error))
                    } else if let document = document, document.exists {
                        do {
                            if let user = try document.data(as: User?.self) {
                                promise(.success(user))
                            } else {
                                promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decode user"])))
                            }
                        } catch {
                            promise(.failure(error))
                        }
                    } else {
                        promise(.failure(NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "User not found"])))
                    }
                }
            }.eraseToAnyPublisher()
        }

        return Publishers.MergeMany(userPublishers)
            .collect()
            .eraseToAnyPublisher()
    }

    // save a user
    func saveUser(userData: User) -> AnyPublisher<Void, Error> {
        Future { promise in
            do {
                try self.firebaseRefrence(.User).document(userData.id).setData(from: userData) { error in
                        if let error = error {
                            promise(.failure(error))
                        } else {
                            promise(.success(()))
                            
                        }
                    
                }
            } catch {
                promise(.failure(error))
            }
            
        }
        .eraseToAnyPublisher()
    }
    
    
    
    // uplaod a user photo
    func uploadImage(image: UIImage, directory:String) -> AnyPublisher<String, Error> {
        Future<String, Error> { promise in
            let filePathUrl =  Storage.storage().reference(forURL: mStorage_BaseUrl).child(directory)

                guard let imageData = image.jpegData(compressionQuality: 0.1) else {
                    promise(.failure(NSError(domain: "ImageUploader", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
                    return
                }
                
                AvatarDirectory.putData(imageData, metadata: nil) { metadata, error in
                    if let error = error {
                        promise(.failure(error))
                        return
                    }
                    
                    AvatarDirectory.downloadURL { url, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if let url = url {
                            if var user = User.currentUser{
                                LocalFileManager.instance.saveFileLocally(image:image, fileName: user.id)
                                user.avatarLink = url.absoluteString
                                User.saveUserLocally(user)
                                promise(.success(url.absoluteString))
                                
                                
                            }
                        }
                    }
                }
            
        }.eraseToAnyPublisher()
    }
    
    
    // helper funcyion to download a user photo
    func downloadImage(_ filename: String) -> Future<UIImage?, Error> {
      let fileNameUrl = "Avatars/" + "_\(filename)" + ".jpg"
     let AvatarFullPathUrl = Storage.storage().reference(forURL: mStorage_BaseUrl).child(fileNameUrl)
        return Future { promise in
            AvatarFullPathUrl.getData(maxSize: 10 * 1024 * 1024) { result in
                switch result {
                case .success(let data):
                    if let image = UIImage(data: data) {
                        promise(.success(image))
                        if let imageData = UIImage(data: data) {
                            LocalFileManager.instance.saveFileLocally(image: imageData, fileName: filename)
                        }
                    } else {
                        promise(.success(nil))
                    }
                case .failure(let error):
                    promise(.failure(error))
                }
            }
        }
    }
    

    
    // read and update a user photo
    func checkAndWriteNSDataToFile(filename:String,avatarUrl:String, completion:@escaping(_ image:UIImage?)->Void) {
        let fileURL = LocalFileManager.instance.fileInDocumentDirectory(filename: filename + ".jpg")
        if FileManager.default.fileExists(atPath: fileURL) {
                
                LocalFileManager.instance.getImageFromLocalStrorage(imagePathUrl: fileURL) { result in
                    if result != nil  {
                        completion(result)

                    }else{
                        completion(nil)

//                        print("user does not have image in localStorage: \(String(describing: result))")

                    }
                    
                }
            
            
        } else {
            print("get from firebase")
            
            FirebaseUserReference.instance.downloadImage(filename)
                .receive(on: DispatchQueue.main)
                .sink { completion in
                    switch completion {
                    case .failure(let error):
                        print("Error downloading image: \(error.localizedDescription)")
                    case .finished:
                        print("download from firebase completed")
                        break
                    }
                } receiveValue: { image in
                    completion(image)
                }
                .store(in: &cancellables)
            
        }
    }
    
}












