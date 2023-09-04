//
//  DateHelper.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import Foundation

struct DateHelper {
    static func CurrentDateTime() -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyyyMMdd-HHmmssSSS"
        return Formatter.string(from: Date())
    }
}
