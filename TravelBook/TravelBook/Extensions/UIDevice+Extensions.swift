//
//  UIDevice+Extensions.swift
//  TravelBook
//
//  Created by ddorsat on 15.05.2026.
//

import Foundation
import SwiftUI

enum ScreenSizeClass {
    case base
    case air
    case plus
}

extension UIDevice {
    static let screenSizeClass: ScreenSizeClass = {
        guard let screen = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.screen
        else {
            return .base
        }

        let bounds = screen.nativeBounds
        let longSide = max(bounds.width, bounds.height)
        let shortSide = min(bounds.width, bounds.height)

        if longSide >= 2770, shortSide >= 1284 {
            return .plus
        }

        if longSide >= 2730 {
            return .air
        }

        return .base
    }()
}
