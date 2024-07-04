//
//  SettingsViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//

//
//  MainViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//

import Foundation
import FirebaseAuth
import SwiftUI
import Combine

class UserProfileViewModel:ObservableObject{
    @StateObject var userService:UserService = UserService()
    @Published var user:User? = nil
    @Published var avatarImage:UIImage? = nil
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
    
    
    
}
