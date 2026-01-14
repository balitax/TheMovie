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
            .background(Color(.systemGroupedBackground))
            .navigationTitle("The Movie")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    ListMovieView()
}
