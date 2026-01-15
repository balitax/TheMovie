//
//  ContentView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {

    @Environment(\.modelContext) private var modelContext
    @State private var selectedTab: AppTab = .home

    var body: some View {
        let container = AppContainer(modelContext: modelContext)

        TabView(selection: $selectedTab) {
            ListMovieView(viewModel: container.makeListMovieViewModel())
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)

            FavoriteMovieView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(AppTab.favorites)
        }
        .tint(AppColor.iconPrimary)
    }
}

#Preview {
    ContentView()
}
