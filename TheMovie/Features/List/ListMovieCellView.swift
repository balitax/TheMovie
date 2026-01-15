//
//  ListMovieCellView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import Kingfisher

struct ListMovieCellView: View {
    
    let movie: MovieEntity
    let onToggleFavorite: (MovieEntity) -> Void

    init(movie: MovieEntity, onToggleFavorite: @escaping (MovieEntity) -> Void) {
        self.movie = movie
        self.onToggleFavorite = onToggleFavorite
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {

            ZStack(alignment: .top) {

                KFImage(movie.posterImageURL)
                    .placeholder {
                        ZStack {
                            Color.gray.opacity(0.15)
                            ProgressView()
                        }
                        .frame(height: 250)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(height: 250)
                    .clipped()

                HStack {

                    Label(movie.releaseDate, systemImage: "calendar.circle.fill")
                        .font(.caption)
                        .foregroundColor(AppColor.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.9))
                        .cornerRadius(8)
                    
                    Spacer()

                    Button(action: {
                        onToggleFavorite(movie)
                    }, label: {
                        Image(systemName: movie.isFavorite ? "heart.fill" : "heart")
                            .font(.caption)
                            .foregroundColor(movie.isFavorite ? AppColor.iconActive : AppColor.iconPrimary)
                            .padding(8)
                            .background(.white.opacity(0.9))
                            .clipShape(Circle())
                    })
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                
            }

            VStack(alignment: .leading, spacing: 4) {
                Text(movie.title)
                    .font(.subheadline.bold())
                    .lineLimit(2)
                    .foregroundColor(AppColor.textPrimary)
                    .frame(height: 40)
                
                HStack(spacing: 6) {
                    Label("\(movie.popularity.toKFormat)", systemImage: "p.circle.fill")
                        .font(.caption)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Label("\(movie.voteAverage.toKFormat)", systemImage: "checkmark.seal.fill")
                        .font(.caption)
                        .font(.caption.bold())
                    
                    Spacer()
                }
                .foregroundColor(AppColor.textSecondary)
            }
            .padding([.horizontal, .bottom], 16)
        }
        .background(AppColor.background)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.1), radius: 8, y: 4)
    }
}

#Preview {
    ListMovieCellView(movie: MovieEntity(), onToggleFavorite: { _ in })
}
