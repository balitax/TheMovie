//
//  FavoriteMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct FavoriteMovieView: View {
    
    private let columns: [GridItem] = Array(
        repeating: GridItem(.flexible(), spacing: 12),
        count: 2
    )
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVGrid(columns: columns, spacing: 16) {
                    ForEach(0..<20, id: \.self) { _ in
                        NavigationLink {
                            DetailMovieView()
                        } label: {
                            ListMovieCellView(movie: MovieEntity())
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
                    Text("Favorite Movie")
                        .font(.headline)
                        .foregroundStyle(AppColor.textPrimary)
                }
            }
        }
    }
}

#Preview {
    FavoriteMovieView()
}
