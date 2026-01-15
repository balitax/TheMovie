//
//  TrailerPlaceholderView.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI
import YouTubePlayerKit

struct TrailerPlaceholderView: View {

    let youtubeURL: String

    var body: some View {
        let player = YouTubePlayer(urlString: youtubeURL)
        YouTubePlayerView(player)
            .background(Color.black)
    }
}
