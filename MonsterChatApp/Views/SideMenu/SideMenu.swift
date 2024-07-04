//
//  SideMenu.swift
//  MonsterChat
//
//  Created by Obaro Paul on 26/06/2024.
//

import SwiftUI
import RiveRuntime

struct SideMenu: View {
    @State var selectedMenu:Menu = .Home
    let icon = RiveViewModel(fileName: "icons", stateMachineName: "HOME_interactivity", artboardName: "HOME")
    var body: some View {
        VStack (spacing:10){
            HStack {
                Image(systemName: "person")
                    .resizable()
                    .frame(width: 30, height: 30)
                
                VStack{
                    Text("User Name")
                        .font(.title3)
                    Text("Hey, i'm using ")
                        .font(.subheadline)
                        .opacity(0.7)
                }
                Spacer()
                
            }.padding(.bottom, 50)
            
            ForEach(menuItems) {item in
                HStack {
                    item.icon.view()
                        .frame(width: 36, height: 36)
                    Text("\(item.text.rawValue)")
                        .font(.title3)
                }.frame(maxWidth: .infinity, alignment: .leading)
                    .background(
                        RoundedRectangle(cornerRadius: 5, style: .continuous)
                            .fill(.teal)
                            .frame(maxWidth: selectedMenu == item.text ? .infinity : 0)
                            .frame(maxWidth:.infinity, alignment:.leading)
                            
                    )
                    .background(Color("Background 2"))
                    
                    .onTapGesture {
                        item.icon.setInput("active", value: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                            item.icon.setInput("active", value: false)
                        })
                        withAnimation{
                            selectedMenu = item.text
                        }
                    }
            }
            Divider()
            Spacer()
        }
        .padding(16)
        .foregroundColor(.white)
        .frame(maxWidth: 288, maxHeight: .infinity)
        .background(Color.fromHex("17203A"))
        .mask(
            RoundedRectangle(cornerRadius: 30, style: .continuous)
        )
        .frame(maxWidth: .infinity, alignment: .leading)
        
        
    }
}

#Preview {
    SideMenu()
}

struct MenuItem:Identifiable{
var id:String = UUID().uuidString
    var icon:RiveViewModel
    var text:Menu
}

enum Menu:String{
    case Home
    case Search
    case Favourite
    case Help
    case AppVersion
}

var menuItems = [
    MenuItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "CHAT_Interactivity", artboardName: "CHAT"), text: .Home ),
    MenuItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "SEARCH_Interactivity", artboardName: "SEARCH"), text: .Search),
    MenuItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "TIMER_Interactivity", artboardName: "TIMER"), text: .Favourite ),
    MenuItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "USER_Interactivity", artboardName: "USER"), text: .Help),
    MenuItem(icon: RiveViewModel(fileName: "icons", stateMachineName: "BELL_Interactivity", artboardName: "BELL"), text: .AppVersion)
]
