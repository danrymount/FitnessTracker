
import SwiftUI

final class RootViewManager: ObservableObject {
    
    // TODO store auth information
    @Published var currentRoot: RootViewType = .welcome
    
    enum RootViewType {
        case welcome
        case main
    }
}

@main
struct FitnessTrackerApp: App {

    @StateObject private var rootViewManager = RootViewManager()
    
    var body: some Scene {
        WindowGroup {
            Group {
                switch rootViewManager.currentRoot {
                case .welcome:
                    WelcomeView()
                case .main:
                    MainView()
                        .transition(.scale.animation(.easeIn(duration: 0.2)))
                }
            }
            .environmentObject(rootViewManager)
        }
    }
}
