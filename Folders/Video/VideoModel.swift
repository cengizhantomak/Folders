//
//  VideoModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import Foundation

struct VideoModel: Identifiable, Codable {
    var id = UUID()
    var CreationDate: Date
    var CustomName: String?
    var Name: String {
        return CustomName ?? DateHelper.CurrentDateTime(from: CreationDate)
    }
    var IsFavorite: Bool = false
    
    init() {
        self.CreationDate = Date()
    }
}
