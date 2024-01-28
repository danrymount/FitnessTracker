
import Foundation
import SwiftUI

enum Tabs: String{
    case Activity
    case Profile
}

struct MainView: View {
    @State var selectedTab: Tabs = .Activity
    
    init() {
        UITabBar.appearance().backgroundColor = UIColor.white
    }
    var body: some View {
        NavigationView {
            TabView(selection: $selectedTab) {
                ActivitiesView()
                    .tabItem {
                        Image(systemName: "figure.walk.circle")
                        Text("Activities")
                    }
                    .tag(Tabs.Activity)
                ProfileView()
                    .navigationTitle("Profile")
                    .navigationBarTitleDisplayMode(.inline)
                
                    .tabItem {
                        Image(systemName: "person.circle")
                        Text("Profile")
                    }
                    .tag(Tabs.Profile)
            }
            .tabViewStyle(DefaultTabViewStyle())
            .navigationTitle(selectedTab.rawValue)
            .navigationBarTitleDisplayMode(.inline)
            .background(Color.white)
            
        }
    }
}


#Preview {
    MainView()
}
