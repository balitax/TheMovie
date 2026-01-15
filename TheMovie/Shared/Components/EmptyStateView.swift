//
//  EmptyStateView.swift
//  TheMovie
//
//  Created by Aguscahyo on 15/01/26.
//

import SwiftUI

struct EmptyStateView: View {
    
    let iconName: String
    let title: String
    let message: String
    
    var body: some View {
        VStack(spacing: 16) {
            Image(systemName: iconName)
                .font(.system(size: 60))
                .foregroundColor(AppColor.iconPrimary.opacity(0.5))
            
            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.bold())
                    .foregroundColor(AppColor.textPrimary)
                
                Text(message)
                    .font(.body)
                    .foregroundColor(AppColor.textSecondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(32)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyStateView(
        iconName: "magnifyingglass",
        title: "No Results Found",
        message: "Try searching for another movie."
    )
}
