//
//  DetailMovieView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct DetailMovieView: View {
    
    @State private var isLiked = false
    @State private var showTrailer = false
    @State private var showPlayInfo = false
    
    private let headerHeight: CGFloat = 420
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {

                GeometryReader { geo in
                    let minY = geo.frame(in: .global).minY
                    let height = minY > 0 ? headerHeight + minY : headerHeight
                    
                    Image("movie_img")
                        .resizable()
                        .scaledToFill()
                        .frame(height: height)
                        .clipped()
                        .offset(y: minY > 0 ? -minY : 0)
                    
                }
                .frame(height: headerHeight)

                VStack(alignment: .leading, spacing: 16) {
                    
                    Capsule()
                        .fill(Color.gray.opacity(0.3))
                        .frame(width: 40, height: 5)
                        .frame(maxWidth: .infinity)
                        .padding(.top, 8)
                    
                    Text("Invincible Iron Man (2008)")
                        .font(.title2.bold())
                        .foregroundColor(AppColor.textPrimary)
                    
                    HStack(spacing: 8) {
                        Label("3 May 2008", systemImage: "calendar")
                        Text("•")
                        Text("ACTION")
                        Text("•")
                        Text("FHD")
                            .fontWeight(.bold)
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
                            showPlayInfo.toggle()
                        } label: {
                            Label("Play", systemImage: "play.fill")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        
                        Button {
                            showTrailer.toggle()
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
                        
                        Text("""
    Double-sized issue! Co-released alongside this summer's surefire blockbuster hit IRON MAN 2, this issue is the perfect jumping-on point for fans of the films and readers new and old alike! New year. New decade. New trade dress. New threats. New loves. New armor. New Tony Stark. New storyline: RESILIENT. Get onboard the Eisner-award winning INVINCIBLE IRON MAN here! Rated A
    """)
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
        .sheet(isPresented: $showTrailer) {
            TrailerPlaceholderView()
        }
        .sheet(isPresented: $showPlayInfo) {
            PlayInfoBottomSheet()
                .presentationDetents([.height(230)])
                .presentationDragIndicator(.visible)
        }
        .navigationTitle("")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isLiked.toggle()
                } label: {
                    Image(systemName: isLiked ? "heart.fill" : "heart")
                        .foregroundColor(isLiked ? AppColor.iconActive : AppColor.iconPrimary)
                }
                .accessibilityIdentifier("like_button")
            }
        }
    }
}

#Preview {
    DetailMovieView()
}
