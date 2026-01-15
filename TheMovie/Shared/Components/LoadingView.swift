//
//  LoadingView.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.1)
                .ignoresSafeArea()

            ProgressView()
                .scaleEffect(1.2)
                .padding(24)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white)
                        .shadow(radius: 10)
                )
        }
        .transition(.opacity)
    }
}
