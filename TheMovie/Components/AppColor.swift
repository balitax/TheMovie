//
//  AppColor.swift
//  TheMovie
//
//  Created by Aguscahyo on 14/01/26.
//

import SwiftUI

enum AppColor {

    // MARK: - Brand
    static let primary = Color(hex: "#2563EB")     // Blue 600
    static let accent = Color(hex: "#EF4444")      // Red 500

    // MARK: - Background
    static let background = Color(hex: "#F9FAFB")  // App background
    static let surface = Color.white               // Card / Sheet

    // MARK: - Text
    static let textPrimary = Color(hex: "#111827") // Gray 900
    static let textSecondary = Color(hex: "#6B7280") // Gray 500
    static let textDisabled = Color(hex: "#9CA3AF")

    // MARK: - Button
    static let buttonPrimary = Color(hex: "#2563EB")
    static let buttonPrimaryText = Color.white

    static let buttonSecondary = Color(hex: "#E5E7EB")
    static let buttonSecondaryText = Color(hex: "#111827")

    static let buttonDisabled = Color(hex: "#E5E7EB")

    // MARK: - Icon
    static let iconPrimary = Color(hex: "#374151") // Gray 700
    static let iconSecondary = Color(hex: "#9CA3AF")
    static let iconActive = Color(hex: "#EF4444")  // Like

    // MARK: - Divider / Border
    static let divider = Color(hex: "#E5E7EB")
    static let border = Color(hex: "#D1D5DB")

    // MARK: - Badge
    static let badgeBackground = Color(hex: "#F3F4F6")
    static let badgeText = Color(hex: "#374151")

    // MARK: - Status
    static let rating = Color(hex: "#FACC15")      // Star
    static let qualityHD = Color(hex: "#22C55E")   // FHD
}
