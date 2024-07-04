//
//  OnBoardingView.swift
//  MonsterChat
//
//  Created by Obaro Paul on 24/06/2024.
//

import SwiftUI

struct OnBoardingView: View {
    
    var body: some View {
   
        NavigationStack{
        VStack {
            Spacer()
            
            // App Logo or Image
            Image(systemName: "message.fill")
                .resizable()
                .scaledToFit()
                .frame(width: 100, height: 100)
                .foregroundColor(Color.fromHex("F77D8E"))
                .padding()
            
            // App Name
            Text("MONSTER CHAT")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundColor(Color.fromHex("F77D8E"))
                .padding(.bottom, 20)
            
            // Descriptive Text
            Text("Welcome to MONSTER CHAT, the best place to chat with your friends and family. Connect instantly and enjoy seamless communication.")
                .font(.body)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .padding(.bottom, 40)
            
            Spacer()
            
            // Get Started Button
            NavigationLink {
                SignInView()
            } label: {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.fromHex("F77D8E"))
                    .cornerRadius(10)
                    .padding(.horizontal)
            }
            
            
            Spacer()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
   
//            SignInView()
//                .transition(.move(edge: .leading).combined(with:.opacity))
//                .overlay(
//                    VStack {
//                        Spacer()
//                        Button(action: {
//                            withAnimation (.spring()) {
//                                showModal.toggle()
//                            }
//                        }, label: {
//                            Image(systemName: "xmark")
//                                .frame(width: 36, height: 36)
//                                .foregroundColor(.black)
//                                .background(.white)
//                                .mask(Circle())
//                                .shadow(color: Color("Shadow"), radius: 5, x: 0, y: 3)
//                        })
//                        .padding()
//                    }
//                        .offset(y: -60)
//                ).zIndex(1)
        }
        
      
    }
    
   





#Preview {
    OnBoardingView()
}
