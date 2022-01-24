//
//  ZedApp.swift
//  Zed
//
//  Created by Pedro Fernandez on 1/19/22.
//

import SwiftUI

@main
struct ZedApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            HomeView()
        }
    }
}
