//
//  PlayInfoBottomSheet.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

struct PlayInfoBottomSheet: View {

    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 16) {

            Image(systemName: "info.circle.fill")
                .font(.system(size: 40))
                .foregroundColor(AppColor.primary)

            Text("Coming Soon")
                .font(.title3.bold())

            Text("This feature will be available in the future.")
                .font(.body)
                .foregroundColor(AppColor.textSecondary)
                .multilineTextAlignment(.center)
                .padding(.horizontal)

            Button {
                dismiss()
            } label: {
                Text("Got it")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .padding(.top, 8)

        }
        .padding(24)
        .background(Color.clear)
    }
}
