//
//  UsersView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 11/06/2024.
//

import SwiftUI

struct UsersView: View {
    @StateObject var userViewModel:UserViewModel = UserViewModel()
    @State private var searchText: String = ""
    @State private var showSearch: Bool = true
    var body: some View {
        NavigationStack{
            VStack(alignment:.leading){
                
                SearchField(searchText: $searchText)
                ScrollView {
                    LazyVStack {
                        if userViewModel.isLoading {
                            ProgressView()
                        }else{
                            
                            ForEach(userViewModel.users){user in
                                //
                                Section{
                                    
                                    NavigationLink(destination: ProfileView(user: user, avatar: userViewModel.userAvatar)) {
                                        UserCell(user: user)
                                        
                                    }
                                    .foregroundColor(.black)
                                    .padding(.bottom, 10)
                                }
                                
                            }
                            
                        }
                    }.padding()
                }
                Spacer()
            }.background(Color(.systemGray5))
                .navigationTitle("Users")
                .onAppear {
                    userViewModel.fetchUsers()
                }
        }
    }
}

#Preview {
    NavigationStack{
        UsersView()
    }
}
