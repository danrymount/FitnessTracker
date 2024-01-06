
import SwiftUI

struct RootScreen: View {
    
    @EnvironmentObject var auth: Auth
    
    var body: some View {
        if auth.loggedIn {
            MainView()
        } else {
            WelcomeView()
        }
    }
}

@main
struct FitnessTrackerApp: App {
    
    var body: some Scene {
        WindowGroup {
            Group {
                RootScreen()
                    .environmentObject(Auth.shared)
            }
        }
    }
}
