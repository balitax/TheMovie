//
//  ListMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct ListMovieView: View {

    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
    
    @State private var searchMovie: String = ""
    @Binding var showSearch: Bool

    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<20, id: \.self) { _ in
                        NavigationLink {
                            DetailMovieView()
                        } label: {
                            ListMovieCellView()
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(16)
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(Color.white, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    Text("The Movie")
                        .font(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                }
            }
            .searchable(
                text: $searchMovie,
                isPresented: $showSearch,
                placement: .navigationBarDrawer(displayMode: .always),
                prompt: "Search movies"
            )
            .onSubmit(of: .search) {
                
            }
            .onChange(of: showSearch) { _, isShown in
                if !isShown {
                    searchMovie = ""
                }
            }
        }
    }
}

#Preview {
    ListMovieView(showSearch: .constant(false))
}
