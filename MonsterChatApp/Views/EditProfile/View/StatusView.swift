//
//  Status.swift
//  MonsterChat
//
//  Created by Obaro Paul on 10/06/2024.
//

import SwiftUI

let status:[String] = [
    "busy",
    "At work"
]

enum UserStatus:String, CaseIterable{
    case online = "Online"
    case available = "Available"
    case atWork = "At Work"
    
    
}

struct StatusView: View {
    
    @State private var isLoading:Bool = false
    @StateObject var userService:UserService = UserService()
    var user:User?{
        User.currentUser
    }
    @State private var currentSelectedStatus:String = (User.currentUser?.status ?? "")
    private func updateStatus(){
        isLoading = true
        if currentSelectedStatus == ""{
            print("username is empty")
            isLoading = false

            return
        }else{
            userService.updateStatus(currentSelectedStatus)
            isLoading = false

        }
    }
    var body: some View {
        Form{
            Section {
                ForEach(UserStatus.allCases, id: \.self){status in
                    HStack{
                        Button(action: {
                            currentSelectedStatus = status.rawValue
                                updateStatus()
                            
                        }, label: {
                            Text(status.rawValue)
                        }).disabled(isLoading)
                        Spacer()
                        if status.rawValue == currentSelectedStatus{
                            if  isLoading{
                                ProgressView()

                            }else{
                                Image(systemName: "checkmark")
                                    .foregroundStyle(.green)
                            }
                            
                            
                        }
                        
                    }
                }
            } header: {
                Text(User.currentUser?.status ?? "")
            }
            
            
            
        }.navigationTitle("Status Update")
            .addBackButton(removeLast: true)
            .navigationBarBackButtonHidden()
            .onAppear(perform: {
//                userService.fetchUser()
            })
           
    }
}

#Preview {
    NavigationStack{
        StatusView()
    }
}
