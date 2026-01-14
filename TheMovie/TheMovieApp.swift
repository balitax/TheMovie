//
//  TheMovieApp.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

@main
struct TheMovieApp: App {
    
    let container = SwiftDataStack.makeContainer()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(container)
    }
}
