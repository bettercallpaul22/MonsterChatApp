//
//  MainViewModel.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//

import Foundation

class MainViewModel:ObservableObject{
    @Published var user:User? = nil
    
    init(){
        getUser()
    }
    
    private func getUser(){
        if let user = User.currentUser {
            self.user = user
        }
        
        if user?.avatarLink != nil {
            // download avater
        }
        
    }
}
