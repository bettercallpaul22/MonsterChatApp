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

class SettingsViewModel:ObservableObject{
    
    @StateObject var userService:UserService = UserService()
    @Published var user:User? = nil
    @Published var avatarImage2:UIImage? = nil
    @Published var isLoggedOut = false
    
    @Published var appVersion:String = ""
    var cancellable = Set<AnyCancellable>()
    
    init(){
        print("init settings")
        //        subscribeToAvatar()
        getAppVersion()
        getUserData()
    }
    
    private func getAppVersion(){
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        } else {
            appVersion = "Unknown"
        }
    }
    
    
    
    func getUserData(){
               DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
        print("SettingsModel avatar get debug")
        
        guard let user = User.currentUser else {return}
        if !user.id.isEmpty && !user.avatarLink.isEmpty{
            self.user = user
            let fileURL = LocalFileManager.instance.fileInDocumentDirectory(filename: user.id + ".jpg")
            
            LocalFileManager.instance.getImageFromLocalStrorage(imagePathUrl: fileURL) { image in
                guard let imagefile = image else{return}
                self.avatarImage2 = imagefile
            }
                       }
        }
        
    }
    
    
    
    
    
    
    
    func logOut(){
      
        do{
       
            try Auth.auth().signOut()
            UserDefaults.standard.removeObject(forKey: mCurrentUser)
            UserDefaults.standard.synchronize()
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                      // Set isLoggedOut to true when logout is successful
                      self.isLoggedOut = true
                  }
            
        }catch{
            print("error logging out user\(error)")
        }
    }
    
    
    
}
