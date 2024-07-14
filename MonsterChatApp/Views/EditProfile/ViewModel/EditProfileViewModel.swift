//
//  EditProfileViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 07/06/2024.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

class EditProfileViewModel:ObservableObject{
    @StateObject var userService:UserService = UserService()
    @Published var user:User? = nil
    @Published var avatar:UIImage? = nil
    @Published var isLoading:Bool = false
     var cancellables = Set<AnyCancellable>()
    
    
    
    @Published var appVersion:String = ""
    var cancellable = Set<AnyCancellable>()
    
    
    init(){
        getUserData()
    }
    
    
    func getUserData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            guard let user = User.currentUser else {return}
            self.user = user
            
            if !user.id.isEmpty && !user.avatarLink.isEmpty{
                
                self.user = user
                LocalFileManager.instance.readAnWriteImage(fileName: user.id, firebaseImageUrlPath: .avatar)
                    .sink { (completion) in
                        switch completion{
                        case .failure(let error):
                            print("get image error:",error.localizedDescription)
                        case .finished:
                            break
                        }
                    } receiveValue: { image in
                        self.avatar = image
                        // i want my view on reload here and update the avatar
                    }.store(in: &self.cancellables)

            }
            
            
        }
        
    }
    
    func updateAvatar(_ avatar:UIImage){
        guard var user = User.currentUser else {return}
        
        FirebaseHelper.instance.uploadImage(image: avatar, directory: .avatar, fileName: user.id)
            .receive(on: DispatchQueue.main)
            .sink { completeion in
                switch completeion{
                case .failure(let error):
                    print("image upload error :", error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { avatarUrl in
                user.avatarLink = avatarUrl
                User.saveUserLocally(user)
                self.user = user
                LocalFileManager.instance.saveImageLocally(image: avatar, fileName: user.id)
                self.getImage(user.id)
            }.store(in: &self.cancellables)

    }
    
    
     func getImage(_ fileName:String){
        LocalFileManager.instance.readAnWriteImage(fileName: fileName, firebaseImageUrlPath: .photoMessage)
            .sink { (completion) in
                switch completion{
                case .failure(let error):
                    print("get image error:",error.localizedDescription)
                case .finished:
                    break
                }
            } receiveValue: { image in
                self.avatar = image
                // i want my view on reload here and update the avatar
            }.store(in: &self.cancellables)
    }
    
    func updateUsername(_ username:String){
        self.isLoading = true
        if var user = User.currentUser {
            user.username = username
            
            FirebaseUserReference.instance.saveUser(userData: user)
                .receive(on: DispatchQueue.main)
                .sink(receiveCompletion: { completion in
                    switch completion{
                    case.failure(let error):
                        print(error.localizedDescription)
                    case.finished:
                        print("user name update completed")
                        
                        User.saveUserLocally(user)
                        self.user = user
                        break
                    }
                }, receiveValue: {
                    self.isLoading = false
                })
                .store(in: &self.cancellables)
            
            
        }
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
}
