//
//  FitnessTrackerApp.swift
//  FitnessTracker
//
//  Created by Илья Хачатрян on 23.12.2023.
//

import SwiftUI

@main
struct FitnessTrackerApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
