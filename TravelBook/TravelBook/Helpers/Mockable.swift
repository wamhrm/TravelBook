//
//  Mockable.swift
//  TravelBook
//

import Foundation

protocol Mockable {
    var image: String { get }
}

extension Mockable {
    var isMock: Bool {
        image.isEmpty
    }
}
