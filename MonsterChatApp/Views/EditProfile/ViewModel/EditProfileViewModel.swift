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
    @Published var avatarImage:UIImage? = nil
    @Published var isLoading:Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    
    
    @Published var appVersion:String = ""
    var cancellable = Set<AnyCancellable>()
    
    
    init(){
        getUserData()
    }
    
    
    func getUserData(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            print("EditProfileViewModel avatar get debug")
            guard let user = User.currentUser else {return}
            if !user.id.isEmpty && !user.avatarLink.isEmpty{
                self.user = user
                let fileURL = LocalFileManager.instance.fileInDocumentDirectory(filename: user.id + ".jpg")
                
                LocalFileManager.instance.getImageFromLocalStrorage(imagePathUrl: fileURL) { image in
                    guard let imagefile = image else{return}
                    self.avatarImage = imagefile
                }
            }
            
            
        }
        
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
