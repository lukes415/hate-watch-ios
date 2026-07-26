//
//  HateWatchApp.swift
//  HateWatch
//
//  Created by Luke Schurman on 10/1/25.
//

import SwiftUI

@main
struct HateWatchApp: App {
    init() {
        // iOS 26 renders the search bar's Cancel button as an icon-only X by default,
        // which sits right next to the text field's own clear-X and reads as duplicated.
        // Forcing a text title restores the old, unambiguous "Cancel" button.
        UIBarButtonItem.appearance(whenContainedInInstancesOf: [UISearchBar.self]).title = "Cancel"
    }

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
