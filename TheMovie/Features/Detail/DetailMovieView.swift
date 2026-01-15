//
//  DetailMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import Kingfisher

struct DetailMovieView: View {

    @State private var viewModel: DetailMovieViewModel
    
    init(viewModel: DetailMovieViewModel) {
        self.viewModel = viewModel
    }

    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    let height = minY > 0 ? viewModel.state.headerHeight + minY : viewModel.state.headerHeight
                    
                    KFImage(viewModel.state.movie?.posterImageURL)
                        .placeholder {
                            ProgressView()
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(height: height)
                        .clipped()
                        .offset(y: minY > 0 ? -minY : 0)
                    
                }
                .frame(height: viewModel.state.headerHeight)

                VStack(alignment: .leading, spacing: 16) {
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    
                    Text(viewModel.state.movie?.title ?? "")
                        .font(.title2.bold())
                        .foregroundColor(AppColor.textPrimary)
                    
                    HStack(spacing: 8) {
                        Label(viewModel.state.movie?.releaseDate ?? "", systemImage: "calendar.circle.fill")
                        Label("\((viewModel.state.movie?.popularity ?? 0).toKFormat)", systemImage: "p.circle.fill")
                            .font(.caption)
                        
                        Text("•")
                            .foregroundColor(.gray)
                        
                        Label("\((viewModel.state.movie?.voteAverage ?? 0).toKFormat)", systemImage: "checkmark.seal.fill")
                            .font(.caption)
                            .font(.caption.bold())
                    }
                    .font(.caption)
                    .foregroundColor(AppColor.textSecondary)
                    
                    HStack(spacing: 4) {
                        Image(systemName: "star.fill")
                            .foregroundColor(.yellow)
                        Text("8.5 / 10")
                            .font(.caption.bold())
                            .foregroundColor(AppColor.textPrimary)
                        Text("(29.2M views)")
                            .font(.caption)
                            .foregroundColor(AppColor.textSecondary)
                    }
                    
                    HStack(spacing: 12) {
                        Button {
                            viewModel.send(.showPlayInfo)
                        } label: {
                            Label("Play", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            viewModel.send(.showTrailer)
                        } label: {
                            Label("Trailer", systemImage: "film")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.bordered)
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 6) {
                        Text("Synopsis")
                            .foregroundColor(AppColor.textPrimary)
                            .font(.headline)

                        Text(viewModel.state.movie?.overview ?? "")
                        .foregroundColor(AppColor.textSecondary)
                    }
                    
                    Divider()
                    
                    InfoRow(title: "Director", value: "Jon Favreau")
                    InfoRow(title: "Duration", value: "2h 6m")
                    InfoRow(title: "Language", value: "English")
                }
                .padding(16)
                .background(.white)
                .clipShape(RoundedTopShape(radius: 24))
                .offset(y: -24)
            }
        }
        .ignoresSafeArea(edges: .top)
        .sheet(isPresented: viewModel.showTrailerBinding) {
            TrailerPlaceholderView()
        }
        .sheet(isPresented: viewModel.showPlayMovieBinding) {
            PlayInfoBottomSheet()
                .presentationDetents([.height(230)])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    viewModel.send(.likeMovie)
                } label: {
                    Image(systemName: viewModel.state.movie?.isFavorite == true ? "heart.fill" : "heart")
                        .foregroundColor(viewModel.state.movie?.isFavorite == true ? AppColor.iconActive : AppColor.iconPrimary)
                }
                .accessibilityIdentifier("like_button")
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }
}
