//
//  DateHelper.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import Foundation

struct DateHelper {
    static func CurrentDateTime(from date: Date = Date()) -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = StringConstants.DateTimeFormat
        return Formatter.string(from: date)
    }
    
    static func CurrentDate(from date: Date = Date()) -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = StringConstants.DateFormat
        return Formatter.string(from: date)
    }
}
