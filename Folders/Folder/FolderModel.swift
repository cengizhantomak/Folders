//
//  FolderModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import Foundation

struct FolderModel: Identifiable, Codable {
    var id = UUID()
    var Name: String
    var IsPinned: Bool = false
    var IsFavorite: Bool = false
}
