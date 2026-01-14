//
//  InfoRow.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct InfoRow: View {

    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Text(title)
                .foregroundColor(AppColor.textPrimary)
            Spacer()
            Text(value)
                .foregroundColor(AppColor.textPrimary)
                .fontWeight(.medium)
        }
        .font(.caption)
    }
}
