//
//  Date+Extensions.swift
//  TravelBook
//
//  Created by ddorsat on 15.05.2026.
//

import Foundation
import SwiftUI

extension Date {
    func customMonthYear() -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ru_RU")
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: self).lowercased()
    }
}
