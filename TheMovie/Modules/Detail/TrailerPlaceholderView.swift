//
//  TrailerPlaceholderView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct TrailerPlaceholderView: View {
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: "film")
                .font(.largeTitle)
            Text("Trailer Player")
                .font(.headline)
            Text("AVPlayer goes here")
                .font(.caption)
                .foregroundColor(AppColor.textSecondary)
        }
        .padding()
    }
}
