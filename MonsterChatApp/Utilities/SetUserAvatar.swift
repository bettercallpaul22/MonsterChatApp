//
//  SetUserAvatar.swift
//  MonsterChat
//
//  Created by Obaro Paul on 18/06/2024.
//

import Foundation
import SwiftUI

class SetUserAvatar:ObservableObject{
    @Published var userAvatar:UIImage? = nil
    @Published  var isLoading:Bool = false
    
    static let instance = SetUserAvatar()
    init(){}
    
    func setAvatar(avatarLink: String, userId: String) {
       DispatchQueue.main.asyncAfter(deadline: .now() + 1.0){
           
           if !userId.isEmpty || !avatarLink.isEmpty{
               FirebaseUserReference.instance.checkAndWriteNSDataToFile(filename: userId, avatarUrl: avatarLink) { image in
                   if image != nil{
                       self.userAvatar = image
                   }else{
                       self.userAvatar = UIImage(named: "userimage")
                   }
               }
     
           }else{
               self.userAvatar = UIImage(named: "userimage")
               print("usernot logged in")                    }
       }
       
   }

}
