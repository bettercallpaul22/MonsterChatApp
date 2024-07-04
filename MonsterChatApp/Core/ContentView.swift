//
//  ContentView.swift
//  ThreadApp
//
//  Created by Obaro Paul on 30/04/2024.
//

import SwiftUI
import RiveRuntime

struct ContentView: View {
    @StateObject var contentModel = ContentViewModel()
    @AppStorage("selectedTab")  var selectedTab:Tab = .chat
    @State var isOpen:Bool = false
    let button = RiveViewModel(fileName: "menu", stateMachineName: "State Machine", autoPlay: false)

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
