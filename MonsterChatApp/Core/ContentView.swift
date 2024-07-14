//
//  ContentView.swift
//  ThreadApp
//
//  Created by Obaro Paul on 30/04/2024.
//

import SwiftUI


struct ContentView: View {
    @StateObject var contentModel = ContentViewModel()
    @State var isOpen:Bool = false
 

    var body: some View {
        Group{
   
            
                if User.currentUser != nil {
                 MainView()
                }else{
                    // if there's no user session
                    SignInView()
                }
            
        }
    }
}

#Preview {
    ContentView()
}
