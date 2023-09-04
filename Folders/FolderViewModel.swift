//
//  FolderViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

class FolderViewModel: ObservableObject {
    @Published var Folders: [FolderModel] = []
    @Published var ShowAlert: Bool = false
    @Published var InputName: String = ""
    
    func AddFolder() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Folders.insert(FolderModel(Name: InputName), at: 0)
        }
    }
    
    func RemoveFolder(WithId Id: UUID) {
        if let Index = Folders.firstIndex(where: { $0.id == Id }) {
            Folders.remove(at: Index)
        }
    }
}
