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
        LoadFolders()
    }
    
    func AddFolder() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Folders.insert(FolderModel(Name: InputName), at: 0)
            SaveFolders()
        }
    }
    
    func RemoveFolder(WithId Id: UUID) {
        if let Index = Folders.firstIndex(where: { $0.id == Id }) {
            Folders.remove(at: Index)
            SaveFolders()
        }
    }
    
    func RenameFolder(WithId Id: UUID, NewName: String) {
        if let Index = Folders.firstIndex(where: { $0.id == Id }) {
            Folders[Index].Name = NewName
            SaveFolders()
        }
    }
    
    private func SaveFolders() {
        if let Encoded = try? JSONEncoder().encode(Folders) {
            UserDefaults.standard.setValue(Encoded, forKey: "Folders")
        }
    }
    
    private func LoadFolders() {
        if let Data = UserDefaults.standard.data(forKey: "Folders"),
           let Decoded = try? JSONDecoder().decode([FolderModel].self, from: Data) {
            Folders = Decoded
        }
    }
}
