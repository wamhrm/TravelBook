//
//  UIDevice+Extensions.swift
//  TravelBook
//
//  Created by ddorsat on 15.05.2026.
//

import Foundation
import SwiftUI

extension UIDevice {
    static var isProMax: Bool {
        guard let screen = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first?.screen
        else {
            return false
        }

        return screen.nativeBounds.height >= 2796
    }
}
