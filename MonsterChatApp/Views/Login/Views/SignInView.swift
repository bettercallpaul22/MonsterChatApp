//
//  SignInView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 24/06/2024.
//

import SwiftUI


struct SignInView: View {
    @StateObject var loginViewModel:SignInViewModel = SignInViewModel()
    @State private var email: String = ""
    @State private var password: String = ""
    @State var inputError:String = ""
    @State var showResendEmailVerificationBtn:Bool = true
    @State var val:Bool = false
    private var validateInput:Bool{
        email.isEmptyOrwithWiteSpace || password.isEmptyOrwithWiteSpace
    }
    
    
    var body: some View {
        NavigationStack{
            ZStack {
                Rectangle()
                    .fill(.regularMaterial)
                VStack {
                    Text("Sign In")
                        .font(.largeTitle)
                    if let user = User.currentUser{
                        Text("Hey \(user.username)!")
                            .font(.headline)
                    }
                    Text("Welcome to MONSTER CHAT!")
                        .font(.headline)
                    Divider()
                    
                    VStack(alignment: .leading) {
                        Text("Email")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        TextField("Email", text: $loginViewModel.email)
                            .customTextField()
                            .padding(.bottom, 20)
                        
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        SecureField("Password", text: $loginViewModel.password)
                            .customTextField(image: Image("Icon Lock"))
                    }
                    
                    HStack{
                        Button(action: {
                            Task{
                                try await loginViewModel.resetPassword()
                            }
                        }, label: {
                            Text("Forget Password")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        })
                        Spacer()
                        Button(action: {
                            Task{
                                loginViewModel.resendEmailVerification(email_: email)
                            }
                        }, label: {
                            Text("Resend Verification")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        })
                    }.padding(.top, 10)
                    
                    
                    
                    HStack {
                        Button(action: {
                            
                            Task{
                                try await  loginViewModel.login()
                            }
                        }, label: {
                            Text(loginViewModel.isLoading ? "Please wait..." : "Sign In")
                                .padding(20)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.fromHex("F77D8E"))
                        }).disabled(loginViewModel.isLoading)
                        
                    }
                    .customConerRadius(20, corners: [.allCorners])
                    .padding(.vertical, 20)
                    .shadow(color: Color.fromHex("F77D8E").opacity(0.4), radius: 20, x: 0, y: 10)
                    .onTapGesture {
                        withAnimation (.spring()) {
                            //                    showModal = true
                        }
                    }
                    
                    HStack {
                        Text("OR")
                            .foregroundStyle(.secondary)
                    }
                    
                    Text("Sign up with Email, Apple or Google")
                        .padding()
                        .foregroundStyle(.secondary)
                    HStack {
                        NavigationLink {
                            SignUpView()
                        } label: {
                            Image("Logo Email")
                        }

                        Spacer()
                        Image("Logo Apple")
                        Spacer()
                        Image("Logo Google")
                    }
                }
                .navigationBarBackButtonHidden()
                .navigationDestination(isPresented: $loginViewModel.isSuccess, destination: {
                    MainView()
                })
                .padding(30)
                .background(.regularMaterial)
                
                .mask(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .padding()
            )
            }.background(.regularMaterial)
                .toolbar(.hidden, for: .tabBar)
            
        }
        
        
    }
}

#Preview {
    SignInView()
}
