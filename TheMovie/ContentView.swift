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
    @State private var isSplashScreenActive = true

    var body: some View {
        ZStack {
            if isSplashScreenActive {
                SplashView()
                    .transition(.opacity)
            } else {
                let container = AppContainer(modelContext: modelContext)

                TabView(selection: $selectedTab) {
                    ListMovieView(viewModel: container.makeListMovieViewModel())
                        .tabItem {
                            Label("Home", systemImage: "house.fill")
                        }
                        .tag(AppTab.home)

                    FavoriteMovieView(viewModel: container.makeFavoriteMovieViewModel())
                        .tabItem {
                            Label("Favorites", systemImage: "heart.fill")
                        }
                        .tag(AppTab.favorites)
                }
                .tint(AppColor.iconPrimary)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                withAnimation(.easeOut(duration: 0.5)) {
                    self.isSplashScreenActive = false
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
