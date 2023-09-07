//
//  FolderViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

class FolderViewModel: ObservableObject {
    @Published var Folders: [FolderModel] = []
    @Published var SelectedFolders: [FolderModel] = []
    @Published var Columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Published var InputName = ""
    @Published var IsSelecting = false
    @Published var ShowBottomBarDeleteAlert = false
    @Published var ShowCreatedAlert = false
    
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var NewName = ""
    
    init() {
        LoadFolders()
    }
    
    var TodayFolders: [FolderModel] {
        return Folders.filter { $0.Name.hasPrefix(DateHelper.CurrentDate()) && !$0.IsPinned }
    }
    
    var SessionFolders: [FolderModel] {
        return Folders.filter { !$0.Name.hasPrefix(DateHelper.CurrentDate()) && !$0.IsPinned }
    }
    
    var PinnedFolders: [FolderModel] {
        return Folders.filter { $0.IsPinned }
    }
    
    func SaveFolders() {
        if let Encoded = try? JSONEncoder().encode(Folders) {
            UserDefaults.standard.setValue(Encoded, forKey: "Folders")
        }
    }
    
    func LoadFolders() {
        if let Data = UserDefaults.standard.data(forKey: "Folders"),
           let Decoded = try? JSONDecoder().decode([FolderModel].self, from: Data) {
            Folders = Decoded
        }
    }
    
    func AddFolder() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Folders.insert(FolderModel(Name: InputName), at: 0)
            SaveFolders()
        }
    }
    
    func AddButtonAction() {
        InputName = DateHelper.CurrentDateTime()
        ShowCreatedAlert = true
    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedFolders.removeAll()
        }
    }
    
    func FavoritesButtonAction() {
        // TODO: Favorites Button
        print("Favorites Tapped")
    }
    
    func PinActionLabel(For Name: String) -> String {
        return Folders.contains { $0.Name == Name && $0.IsPinned } ? "Unpin" : "Pin"
    }
    
    func PinFolder(For Folder: FolderModel) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders[Index].IsPinned.toggle()
                SaveFolders()
            }
        }
    }
    
    func RenameFolder(For Folder: FolderModel, NewName: String) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders[Index].Name = NewName
                SaveFolders()
            }
        }
    }
    
    func RemoveFolder(For Folder: FolderModel) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders.remove(at: Index)
                SaveFolders()
            }
        }
    }
}
