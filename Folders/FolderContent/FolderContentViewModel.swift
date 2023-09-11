//
//  FolderContentViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import Foundation

class FolderContentViewModel: ObservableObject {
    @Published var Folder: FolderModel
    
    init(Folder: FolderModel) {
        self.Folder = Folder
    }
}
