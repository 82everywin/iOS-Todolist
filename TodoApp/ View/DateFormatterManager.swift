//
//  DateFormatterManager.swift
//  TodoApp
//
//  Created by 한현승 on 6/17/24.
//

import Foundation


class DateFormatterManager {
    static let shared = DateFormatterManager()
    
    private let dateFormatter: DateFormatter
    
    private init() {
        dateFormatter = DateFormatter()
        dateFormatter.timeZone = TimeZone.current
    }
    
    func string(from date: Date, format: String) -> String {
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: date)
    }
    
    func date(from string: String, format: String) -> Date? {
        dateFormatter.dateFormat = format
        return dateFormatter.date(from: string)
    }
}
