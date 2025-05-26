/*
*  File: LittleLemonApp.swift
*  Project: LittleLemonApp
*  Author: macitch.(@https://www.github.com/macitch)
*  Created: on 23.05.2025.
*  Copyright (C) 2025. macitch.
*/

import SwiftUI

@main
struct LittleLemonApp: App {
    let persistenceController = PersistenceController.shared
    
    var body: some Scene {
        WindowGroup {
            OnboardingView().environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
