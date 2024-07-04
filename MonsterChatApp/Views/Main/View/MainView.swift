import SwiftUI

struct MainView: View {
    @State private var selectedTab: Int = 0
    var body: some View {
        
        TabView(selection: $selectedTab) {
            ChatView()
                .tabItem {
                    Image(systemName: "message.circle.fill")
                }
                .tag(0)
            
            ChannelView()
                .tabItem {
                    Image(systemName: "quote.bubble")
                }
                .tag(1)
            
            UsersView()
                .tabItem {
                    Image(systemName: "person.3.fill")
                }
                .tag(2)
            
            SettingsView()
                .tabItem {
                    Image(systemName: "gearshape")
                }
                .tag(3)
        }
        .navigationBarBackButtonHidden(true)
        .navigationTitle(navigationTitle)
    }
    
    
    private var navigationTitle: String {
        switch selectedTab {
        case 0:
            return "Chat"
        case 1:
            return "Channel"
        case 2:
            return "Users"
        case 3:
            return "Settings"

        default:
            return "Main"
        }
        
    }
}

#Preview {
    NavigationStack{
        MainView()
    }
}
