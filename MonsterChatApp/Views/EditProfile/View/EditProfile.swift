//
//  EditProfile.swift
//  MonsterChat
//
//  Created by Obaro Paul on 06/06/2024.
//



import SwiftUI
import PhotosUI

struct EditProfile: View {
    //    @StateObject var userService:UserService = UserService()
    @StateObject private var editProfileModel = EditProfileViewModel()
    @StateObject private var userService = UserService()

    @State var profileName:String = ""
    @State var username:String = ""
    @State private var status:String = ""
    @State private var avatar:UIImage? = nil
    @State private var photoPickerItem:PhotosPickerItem?
    @FocusState private var isFocused: Bool
    @State private var isLoading:Bool = false
    
    var user:User?{
        User.currentUser
    }
    
    var statusList = ["Online", "Busy", "At work", "On vacation"]
    
    private func updateUserName(){
        isLoading = true
        editProfileModel.updateUsername(username.isEmpty ? (user?.username ?? "") : username)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            isLoading = false
            
        }
    }
    
    var body: some View {
        NavigationStack{
            Form{
                Section {
                    HStack(alignment:.top){
                        PhotosPicker(selection: $photoPickerItem, matching: .images) {
                            VStack{
                                if avatar == nil{
                                    if editProfileModel.avatarImage != nil {
                                        Image(uiImage: editProfileModel.avatarImage!)
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
                                    
                                    
                                }
                                
                                if avatar != nil {
                                    Image(uiImage: avatar!)
                                        .resizable()
                                        .frame(width: 50, height: 50)
                                        .clipShape(Circle())
                                        .overlay(Circle().stroke(Color.white, lineWidth: 4))
                                        .shadow(radius: 10)
                                }
                                
                            }
                        }
                        
                        
                        HStack {
                            TextField("Enter your name and add an optional profile picture", text: $profileName, axis: .vertical)
                                .textInputAutocapitalization(.never)
                            
                                .padding(.horizontal, 10)
                                .overlay (
                                    Button(action: {
                                        self.profileName = ""
                                        print("overlay")
                                    }) {
                                        Image(systemName: "xmark.circle.fill") // Example button image
                                            .foregroundColor(.gray)
                                            .clipShape(Circle())
                                    }, alignment: .trailing
                                )
                            
                            
                        }
                        
                        
                        
                    }
                    if let user = editProfileModel.user {
                        TextField(user.username, text: $username, axis: .vertical)
                            .padding(.horizontal, 10)
                            .textInputAutocapitalization(.never)
                            .focused($isFocused)
                            .overlay (
                                Button(action: {
                                    self.username = ""
                                }) {
                                    Image(systemName: "xmark.circle.fill") // Example button image
                                        .foregroundColor(.gray)
                                        .clipShape(Circle())
                                }, alignment: .trailing
                            )
                        
                        //                TextField(editProfileModel.user?.username ?? "Unknown User", text: $username, axis: .vertical)
                        
                        //                TextField(editProfileModel.user!.username, text: $username, axis: .vertical)
                    } else {
                        // Handle the case where user is nil
                        Text("User not found")
                    }
                    
                    
                    
                } header: {
                    Text("change profile image and name")
                }
                
                
                Section {
                    Button {
                        NavigationManager.shared.navigateTo(.status)
                        
                    } label: {
                        if let user = editProfileModel.user {
                            Text(user.status)
                                .foregroundStyle(.black)
                            
                        }
                    }
                    
                    
                } header: {
                    //                Text(User.currentUser!.status)
                }
                
                // error message
                //            if !userService.errorMessage.isEmpty{
                //                Text(userService.errorMessage)
                //                    .foregroundStyle(.red)
                //            }
                
                Button(action: {
                    print("click btn")
                    updateUserName()
                }) {
                    Text(isLoading ? "Please wait..." : "Save")
                        .fontWeight(.bold)
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: UIScreen.main.bounds.width - 54 , height: 50)
                        .background(Color.purple)
                        .cornerRadius(10)
                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
                }
                .buttonStyle(PlainButtonStyle()) // Remove default button style
                
            }.navigationTitle("Edit Profile")
//                .addBackButton(removeLast: true)
                .onAppear(perform: {
                    //                userService.persistUser()
                    //                        userService.fetchUserAvatar()
                })
                .onChange(of: photoPickerItem) { oldValue, newValue in
                    Task{
                        if let photoPickerItem{
                            let data = try? await photoPickerItem.loadTransferable(type: Data.self)
                            if let image = UIImage(data: data!){
                                avatar = image
                                guard let avatarImg = avatar else{
                                    return
                                }
                                
                                //                            print("avatarIMG", avatarImg)
                                userService.updateAvatar(avatar: avatarImg)
                                
                            }
                        }
                    }
                }
        }
        
    }
    
}


#Preview {
    NavigationStack{
        EditProfile()
    }
}
