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
    
    init() {
        loadFolders()
    }
    
    func AddFolder() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Folders.insert(FolderModel(Name: InputName), at: 0)
            saveFolders()
        }
    }
    
    func RemoveFolder(WithId Id: UUID) {
        if let Index = Folders.firstIndex(where: { $0.id == Id }) {
            Folders.remove(at: Index)
            saveFolders()
        }
    }
    
    private func saveFolders() {
        if let encoded = try? JSONEncoder().encode(Folders) {
            UserDefaults.standard.setValue(encoded, forKey: "Folders")
        }
    }
    
    private func loadFolders() {
        if let data = UserDefaults.standard.data(forKey: "Folders"),
           let decoded = try? JSONDecoder().decode([FolderModel].self, from: data) {
            Folders = decoded
        }
    }
}
