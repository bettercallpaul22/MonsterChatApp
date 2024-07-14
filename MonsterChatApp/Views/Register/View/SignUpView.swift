//
//  SignInView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 24/06/2024.
//

import SwiftUI


struct SignUpView: View {
    @StateObject var signUpViewModel:SignUpViewModel = SignUpViewModel()
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
                    Text("Sign Up")
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
                        
                        TextField("Email", text: $signUpViewModel.email)
                            .customTextField()
                            .padding(.bottom, 20)
                        
                        Text("Password")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        SecureField("Password", text: $signUpViewModel.password)
                            .customTextField(image: Image("Icon Lock"))
                    }
                    
                    HStack{
                        Button(action: {
                            Task{
                                try await signUpViewModel.resetPassword()
                            }
                        }, label: {
                            Text("Forget Password")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        })
                        Spacer()
                        Button(action: {
                            Task{
                                signUpViewModel.resendEmailVerification(email_: email)
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
                                try await  signUpViewModel.register()
                            }
                        }, label: {
                            Text(signUpViewModel.isLoading ? "Please wait..." : "Sign Up")
                                .padding(20)
                                .fontWeight(.heavy)
                                .frame(maxWidth: .infinity)
                                .foregroundColor(.white)
                                .background(Color.fromHex("F77D8E"))
                        }).disabled(signUpViewModel.isLoading)
                        
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
                    
                    Text("Sign In with Email, Apple or Google")
                        .padding()
                        .foregroundStyle(.secondary)
                    HStack {
                        NavigationLink {
                            SignInView()
                        } label: {
                            Image("Logo Email")
                        }

                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("Logo Apple")
                        })
                        Spacer()
                        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                            Image("Logo Google")
                        })
                        
                     
                    }
                }
                .navigationDestination(isPresented: $signUpViewModel.isSuccess, destination: {
                    SignInView()
                })
                .padding(30)
                .background(.regularMaterial)
                
                .mask(
                    RoundedRectangle(cornerRadius: 20, style: .continuous)
                        .padding()
            )
            }.background(.regularMaterial)
            
        }
        
        
    }
}

#Preview {
    SignUpView()
}
