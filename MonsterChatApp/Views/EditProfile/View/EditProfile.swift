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
    @State private var showImagePicker:Bool = false
    
    
    @State var profileName:String = ""
    @State var username:String = ""
    @State private var status:String = ""
    @State private var avatar:UIImage? = nil
    @State private var photoPickerItem:PhotosPickerItem?
    @FocusState private var isFocused: Bool
    @State private var isLoading:Bool = false
    @State var photo:UIImage? = nil
    
    
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
            VStack {
                HStack{
                    Spacer()
                    
                    // if photo picker has a photo
                    if let photo = photo{
                        VStack {
                            Button {
                                showImagePicker = true
                            } label: {
                                CircularImage(image: photo, size: .large)
                                    .overlay(alignment: .trailing, content: {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .offset(x:10, y: -30)
                                    })
                            }
                            
                            
                        }
                        
                    }
                    
                    // if photo picker is nil and user avatar is nil
                    if photo == nil && editProfileModel.avatar == nil{
                        VStack {
                            Button {
                                showImagePicker = true
                            } label: {
                                CircularImage(image: photo, size: .large)
                                    .overlay(alignment: .trailing, content: {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .offset(x:10, y: -30)
                                    })
                            }
                            
                            
                        }
                        
                    }
                    
                    
                    if editProfileModel.avatar != nil && photo == nil{
                        VStack {
                            Button {
                                showImagePicker = true
                            } label: {
                                CircularImage(image: editProfileModel.avatar!, size: .large)
                                    .overlay(alignment: .trailing, content: {
                                        Image(systemName: "square.and.pencil")
                                            .resizable()
                                            .frame(width: 30, height: 30)
                                            .offset(x:10, y: -30)
                                    })
                            }
                            
                            
                        }
                    }
                    
                    Spacer()
                    
                }
                VStack{
                    Text(user?.username ?? "NO USER")
                        .bold()
                    
                    if let user = editProfileModel.user {
                        NavigationLink(destination: StatusView()) {
                            Text(user.status)
                        }
                    } else {
                        Text("No status available")
                        
                    }
                }.padding(.top, 20)
                    .foregroundColor(.black)
               
                
                HStack {
                    CustomButton(loadingState: isLoading, title: "Save") {
                        updateUserName()

                    }
                   
                    
                }
         
                
                
                Spacer()
                
            }
            .padding()
            .sheet(isPresented: $showImagePicker, content: {
                PhotoPicker(Image: $photo){
                    if let photo = photo{
                        editProfileModel.updateAvatar(photo)
                    }
                }
            })
            .navigationTitle("Edit Profile")
            .onAppear(perform: {
                if let userId = user?.id{
                    editProfileModel.getImage(userId)
                    
                }
            })
            
            //            Form{
            //                Section {
            //                    HStack{
            //                        Spacer()
            //
            //
            //                        if let photo = photo{
            //                            VStack {
            //                                Button {
            //                                    showImagePicker = true
            //                                } label: {
            //                                    CircularImage(image: photo, height: 90, width: 90)
            //                                        .overlay(alignment: .trailing, content: {
            //                                            Image(systemName: "square.and.pencil")
            //                                                .resizable()
            //                                                .frame(width: 30, height: 30)
            //                                                .offset(x:10, y: -30)
            //                                        })
            //                                }
            //
            //                                Text(user?.username ?? "NO USER")
            //                                    .bold()
            //                            }
            //
            //                        }
            //
            //
            //                        if editProfileModel.avatar != nil && photo == nil{
            //                            VStack {
            //                                Button {
            //                                    showImagePicker = true
            //                                } label: {
            //                                    CircularImage(image: editProfileModel.avatar!, height: 90, width: 90)
            //                                        .overlay(alignment: .trailing, content: {
            //                                            Image(systemName: "square.and.pencil")
            //                                                .resizable()
            //                                                .frame(width: 30, height: 30)
            //                                                .offset(x:10, y: -30)
            //                                        })
            //                                }
            //
            //                                Text(user?.username ?? "NO USER")
            //                                    .bold()
            //                            }
            //                        }
            //
            //
            //                        Spacer()
            //
            //                    }
            //
            //                } header: {
            //                    Text("change profile image and name")
            //                }
            //
            //
            //                Section {
            //                    if let user = editProfileModel.user {
            //                        NavigationLink(destination: StatusView()) {
            //                            Text(user.status)
            //                        }
            //                    } else {
            //                        // Handle the case where user is nil, if needed
            //                        Text("No status available")
            //                    }
            //
            //
            //
            //                }
            //
            //                Button(action: {
            //                    updateUserName()
            //                }, label: {
            //                    Text(isLoading ? "Please wait..." : "Save")
            //                        .padding(20)
            //                        .fontWeight(.heavy)
            //                        .frame(maxWidth: .infinity)
            //                        .foregroundColor(.white)
            //                        .background(Color.fromHex("F77D8E"))
            //                }).disabled(isLoading)
            //
            ////                Button(action: {
            ////                    updateUserName()
            ////                }) {
            ////                    Text(isLoading ? "Please wait..." : "Save")
            ////                        .fontWeight(.bold)
            ////                        .font(.headline)
            ////                        .foregroundColor(.white)
            ////                        .frame(width: UIScreen.main.bounds.width - 54 , height: 50)
            ////                        .background(Color.purple)
            ////                        .cornerRadius(10)
            ////                        .shadow(color: Color.black.opacity(0.5), radius: 4, x: 0, y: 2)
            ////                }
            ////                .buttonStyle(PlainButtonStyle()) // Remove default button style
            //
            //            } .sheet(isPresented: $showImagePicker, content: {
            //                PhotoPicker(Image: $photo){
            //                    if let photo = photo{
            //                        editProfileModel.updateAvatar(photo)
            //                    }
            //                }
            //            })
            //            .navigationTitle("Edit Profile")
            //            .onAppear(perform: {
            //                if let userId = user?.id{
            //                    editProfileModel.getImage(userId)
            //
            //                }
            //            })
            
        }
        
    }
    
}


#Preview {
    NavigationStack{
        EditProfile()
    }
}
