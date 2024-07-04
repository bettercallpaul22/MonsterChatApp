//
//  SettingsView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//

import SwiftUI

struct SettingsView: View {
    
    @StateObject var userService:UserService = UserService()
    @StateObject private var settingsViewModel = SettingsViewModel()
    
//    private func logOut(){
//        settingsViewModel.logOut { error in
//            if error == nil{
//                print("logged out")
//                NavigationManager.shared.navigateTo(.login)
//            }else{
//                print("Logout failed")
//                
//            }
//        }
//    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    NavigationLink(destination: EditProfile()) {
                        HStack(alignment:.top){
                            if settingsViewModel.avatarImage2 != nil {
                                Image(uiImage: settingsViewModel.avatarImage2!)
                                    .resizable()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                            }else{
                                Image(systemName: "person.crop.circle")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 50, height: 50)
                                    .clipShape(Circle())
                                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                    .shadow(radius: 10)
                            }
                            
                            
                            VStack(alignment: .leading, spacing: 10){
                                
                                Text(settingsViewModel.user?.username ?? "")
                                    .foregroundStyle(.black)
                                    .bold()
                                
                                Text(settingsViewModel.user?.status ?? "no status")
                                    .foregroundStyle(.gray)
                            }
                            
                        }
                    }
                    
                }
                
                
                
                Section {
                    HStack{
                        Text("Invite a Friend")
                        
                        Spacer()
                        Button(action: {
                            print("invite frnd")
                            
                        }
                               , label: {
                            Image(systemName: "arrow.forward")
                                .foregroundColor(.gray)
                        })
                    }
                    
                    HStack{
                        Text("Terms and Condition")
                        
                        
                        
                        Spacer()
                        Button(action: {
                            print("invite frnd")
                            
                        }
                               , label: {
                            Image(systemName: "arrow.forward")
                                .foregroundColor(.gray)
                        })
                    }
                    
                    
                }
                
                Section {
                    Text(" App version \(settingsViewModel.appVersion)")
                    
                    HStack(alignment:.center){
                        Text("")
                        Spacer()
                        Button(action: {
                            settingsViewModel.logOut()
                        }
                               , label: {
                            Text("Logout")
                                .foregroundStyle(.red)
                                .font(.title2)
                        })
                        Spacer()
                        
                        Text("")
                    }
                }
                
                
            }.navigationBarBackButtonHidden()
                .navigationTitle("Settings")
                .onAppear {
                    settingsViewModel.getUserData()
                    
                }
              
                .navigationDestination(isPresented: $settingsViewModel.isLoggedOut, destination: {
                    SignInView()
                })
            
        }
    }
    
}


#Preview {
    SettingsView()
}
