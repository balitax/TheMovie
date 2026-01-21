//
//  Text+Extensions.swift
//  TheMovie
//
//  Created by Aguscahyo on 21/01/26.
//

import SwiftUI

extension Text {
    static func highlighted(
        _ text: String,
        matching query: String,
        highlightColor: Color = .accentColor
    ) -> Text {
        guard !query.isEmpty else {
            return Text(text)
        }

        let lowercasedText = text.lowercased()
        let lowercasedQuery = query.lowercased()

        guard let range = lowercasedText.range(of: lowercasedQuery) else {
            return Text(text)
        }

        let startIndex = text.distance(from: text.startIndex, to: range.lowerBound)
        let endIndex = text.distance(from: text.startIndex, to: range.upperBound)

        let prefix = String(text.prefix(startIndex))
        let match = String(text[text.index(text.startIndex, offsetBy: startIndex)..<text.index(text.startIndex, offsetBy: endIndex)])
        let suffix = String(text.suffix(text.count - endIndex))

        return
            Text(prefix) +
            Text(match)
                .foregroundColor(highlightColor)
                .fontWeight(.bold) +
            Text(suffix)
    }
}
