//
//  User.swift
//  MonsterChat
//
//  Created by Obaro Paul on 04/06/2024.
//

import Foundation
import FirebaseAuth
import FirebaseFirestoreSwift

struct User:Codable, Equatable, Identifiable {
    var id:String = ""
    var email:String
    var username:String
    var pushId:String = ""
    var avatarLink:String = ""
    var status:String
    
    
    static var currentUserId:String?{
        if Auth.auth().currentUser != nil {
            return Auth.auth().currentUser?.uid

        }else{
            return nil
        }
    }
    
    static var currentUser:User?{
        if Auth.auth().currentUser != nil{
            if let dictionary = UserDefaults.standard.data(forKey: mCurrentUser){ // check if have a user in our localStorage
                do{
                    let userObject = try JSONDecoder().decode(User.self, from: dictionary)
                    return userObject
                }catch{
                    print("error from user default \(error.localizedDescription)")
                }
            }
        }
        return nil
    }
    
    
    static func == (lhs:User, rhs:User) -> Bool {
        lhs.id == rhs.id
    }
    
    static var dummyUser:User{
        User(email: "johndoe@mail.com", username: "@johndoe", status: "hey i am using monster chat")
        
    }
    
    static func saveUserLocally(_ user:User){
        do{
        let data =  try JSONEncoder().encode(user)
            UserDefaults.standard.set(data, forKey: mCurrentUser)
        }catch{
            print("error encoding user \(error.localizedDescription)")
        }
    }
    
    
  
    
    
    
    
    
    
    
    
}

