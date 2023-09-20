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
    var Name: String
    var IsFavorite: Bool = false
    var AssetVideoName: String?
    
    init() {
        self.CreationDate = Date()
        self.Name = Date.CurrentDateTime()
    }
}
