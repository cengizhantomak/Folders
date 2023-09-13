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
    var CustomName: String?
    var Videos: [VideoModel]?
    var Name: String {
        return CustomName ?? DateHelper.CurrentDateTime(from: CreationDate)
    }
    
    init() {
        self.CreationDate = Date()
    }
    
    // For Previews
    init(Name: String) {
        self.init()
        self.CustomName = Name
    }
}
