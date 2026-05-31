//
//  AlertPresentable.swift
//  TravelBook
//

import Foundation

@MainActor
protocol AlertPresentable: AnyObject {
    var showAlert: Bool { get set }
    var alertMessage: String { get set }
}

extension AlertPresentable {
    func presentAlert(_ message: String) {
        alertMessage = message
        showAlert = true
    }
}
