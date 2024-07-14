//
//  EditProfileViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 07/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import SwiftUI
import Combine


class UserService:ObservableObject{
    static var instance = UserService()
    @Published var user:User? = nil
    @Published var avatar:UIImage? = nil
    @Published var appVersion:String = ""
    @Published var isLoading:Bool = false
    @Published var errorMessage:String = ""
    @Published var progressCount:CGFloat = 0
    private var cancellables = Set<AnyCancellable>()
    
    init(){
//        fetchUserAvatar()
    }
    
    func persistUser(){
        if let user = User.currentUser {
            self.user = user
        }
    }
    
    
    
    func getAvatar(_ fileName:String, directory:FireBaseImageUrlPath){
  isLoading = true
        LocalFileManager.instance.readAnWriteImage(fileName: fileName, firebaseImageUrlPath: directory.self)
            .sink { (completion) in
                switch completion{
                case .failure(let error):
                    print("get image error:",error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { image in
                self.avatar = image
            }.store(in: &self.cancellables)
    }
    
    // look into fetch user
//    func fetchUserAvatar(){
//        if let user = User.currentUser {
//            self.user = user
//            if user.avatarLink != "" {
//                FirebaseUserReference.instance.checkAndWriteNSDataToFile(filename:user.id, avatarUrl: user.avatarLink){image in
//                    if image != nil{
//                        self.avatarImage = image
//                    }else{
//                        self.avatarImage = nil
//                        
//                    }
//                }
//                
//            }
//            
//        }
//    }
//    
//    
    
//    func updateAvatar(avatar:UIImage){
//        guard let userId = User.currentUserId else {return}
//        self.isLoading = true
//        FirebaseUserReference.instance.uploadImage(image: avatar, directory: mFirebaseImageDirectory, fileName:userId)
//            .receive(on: DispatchQueue.main)
//            .sink(receiveCompletion: { completion in
//                switch completion{
//                case.failure(let error):
//                    print(error.localizedDescription)
//                case.finished:
//                    print("Image uplaod completed")
//                    
//                }
//            }, receiveValue: { url in
//                
//            })
//            .store(in: &self.cancellables)
//        
//    }
//    
//    
    
  
    func updateStatus(_ status:String){
        self.isLoading = true
        if var user = User.currentUser {
            user.status = status
            
            FirebaseUserReference.instance.saveUser(userData: user)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case.failure(let error):
                        print(error.localizedDescription)
                    case.finished:
                        print(" Status update completed")
                        User.saveUserLocally(user)
                    }
                }, receiveValue: {
                    print("User saved successfully")
                    self.isLoading = false
                })
                .store(in: &self.cancellables)
        }else{
            self.isLoading = false
            print("user not logged in")
        }
        
    }
    
    
    func logOut(completion:@escaping(_ error:Error?)->Void){
        do{
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: mCurrentUser)
            completion(nil)
            
        }catch{
            completion(error)
            print("error logging out user\(error)")
        }
    }
    
    
    
}

