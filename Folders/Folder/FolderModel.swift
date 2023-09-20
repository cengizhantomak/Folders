//
//  FolderModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import Foundation

struct FolderModel: Identifiable, Codable {
    var id = UUID()
    var IsPinned: Bool = false
    var IsFavorite: Bool = false
    var CreationDate: Date
    var Videos: [VideoModel]?
    var Name: String
    
    init() {
        self.CreationDate = Date()
        self.Name = Date.CurrentDateTime()
    }
    
    // For Previews
    init(Name: String) {
        self.init()
    }
}
