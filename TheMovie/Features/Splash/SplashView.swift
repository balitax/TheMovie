//
//  SplashView.swift
//  TheMovie
//
//  Created by Antigravity on 15/01/26.
//

import SwiftUI

struct SplashView: View {
    
    @State private var isActive = false
    @State private var scale = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                Image(systemName: "film.stack.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 80, height: 80)
                    .foregroundStyle(
                        LinearGradient(
                            colors: [AppColor.iconActive, .white.opacity(0.8)],
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                
                Text("THE MOVIE")
                    .font(.system(size: 32, weight: .black, design: .rounded))
                    .kerning(4)
                    .foregroundStyle(.white)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.2)) {
                    self.scale = 1.0
                    self.opacity = 1.0
                }
            }
        }
    }
}

#Preview {
    SplashView()
}
