//
//  DateFormater.swift
//  Snapsea
//
//  Created by Irina Deeva on 12/09/24.
//

import Foundation

extension DateFormatter {
    static let russianDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM yyyy"
        formatter.locale = Locale(identifier: "ru_RU")
        return formatter
    }()
}
