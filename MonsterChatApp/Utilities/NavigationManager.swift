//
//  NavigationManager.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//

import Foundation
import SwiftUI

enum Destination: Codable, Equatable{
    case main
    case login
    case register
    case editProfile
    case status
}


class NavigationManager: ObservableObject {
    static let shared = NavigationManager()
    
    @Published var path = NavigationPath()
    
    
    
    
    func navigateTo(_ view: Destination) {
        
        switch view {
        case .main:
            path.append(Destination.main) // Remove all views
        case .login:
            path.append(Destination.login)
        case .register:
            path.append(Destination.register)
          case .editProfile:
           path.append(Destination.editProfile)
        case .status:
         path.append(Destination.status)
            
        }
    }
}
