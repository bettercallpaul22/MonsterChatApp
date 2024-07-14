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
    @Published var avatar:UIImage? = nil
    @Published var isLoggedOut = false
    
    @Published var appVersion:String = ""
    var cancellables = Set<AnyCancellable>()
    
    init(){
        getAppVersion()
    }
    
    private func getAppVersion(){
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            appVersion = version
        } else {
            appVersion = "Unknown"
        }
    }
    
    
    
    func getUserData(){
//        UserDefaults.standard.synchronize()
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
            
            guard let user = User.currentUser else {return}
            self.user = user
            print("settingsModel getUserData", user)
            
//            if !user.id.isEmpty && !user.avatarLink.isEmpty{
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
//                        print("settings view model get avatar", image)
                        self.avatar = image
                    }.store(in: &self.cancellables)
                
                
//            }
//        }
        
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
