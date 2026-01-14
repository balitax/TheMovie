//
//  ListMovieCellView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct ListMovieCellView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            
            ZStack(alignment: .top) {

                Image("movie_img")
                    .resizable()
                    .scaledToFill()
                    .frame(maxHeight: 250)
                    .clipped()

                HStack {
                    
                    Label("3 May 2008", systemImage: "calendar")
                        .font(.caption)
                        .foregroundColor(AppColor.textPrimary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(.white.opacity(0.9))
                        .cornerRadius(8)
                    
                    Spacer()
                    
                    Button(action: {
                        
                    }, label: {
                        Image(systemName: "heart")
                            .font(.caption)
                            .foregroundColor(AppColor.textPrimary)
                            .padding(8)
                            .background(.white.opacity(0.9))
                            .clipShape(Circle())
                    })
                }
                .padding(.horizontal, 4)
                .padding(.vertical, 8)
                
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Invincible Iron Man (2008)")
                    .font(.subheadline.bold())
                    .lineLimit(2)
                    .foregroundColor(AppColor.textPrimary)
                
                HStack(spacing: 6) {
                    Text("ACTION")
                        .font(.caption)
                    
                    Text("•")
                        .foregroundColor(.gray)
                    
                    Text("FHD")
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
    ListMovieCellView()
}
