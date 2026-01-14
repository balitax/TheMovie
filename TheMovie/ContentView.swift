//
//  ContentView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State private var selectedTab: AppTab = .home
    @State private var showSearch = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            ListMovieView(showSearch: $showSearch)
                .tabItem {
                    Label("Home", systemImage: "house.fill")
                }
                .tag(AppTab.home)
            
            FavoriteMovieView()
                .tabItem {
                    Label("Favorites", systemImage: "heart.fill")
                }
                .tag(AppTab.favorites)
            
            Color.clear
                .tabItem {
                    Label("Search", systemImage: "magnifyingglass")
                }
                .tag(AppTab.search)
        }
        .tint(AppColor.iconPrimary)
        .onChange(of: selectedTab) { _, newTab in
            if newTab == .search {
                selectedTab = .home
                showSearch = true
            }
        }
    }
}

#Preview {
    ContentView()
}
