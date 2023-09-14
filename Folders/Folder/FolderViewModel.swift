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
    @Published var OnlyShowFavorites = false
    @Published var ShowBottomBarDeleteAlert = false
    @Published var ShowCreatedAlert = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var NewName = ""
    @Published var FolderToRename: FolderModel?
    
    init() {
        LoadFolders()
    }
    
    var TodayFolders: [FolderModel] {
        let Today = Date()
        return Folders.filter {
            Calendar.current.isDate($0.CreationDate, inSameDayAs: Today) && !$0.IsPinned
        }.sorted(by: { $0.CreationDate > $1.CreationDate })
    }

    
    var SessionFolders: [FolderModel] {
        let Session = Date()
        return Folders.filter {
            !Calendar.current.isDate($0.CreationDate, inSameDayAs: Session) && !$0.IsPinned
        }
    }
    
    var FavoriteFolders: [FolderModel] {
        return Folders.filter { $0.IsFavorite }
    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - Padding) / Amount
    }
    
    func SaveFolders() {
        UserDefaultsManager.Shared.Save(Folders, ForKey: StringConstants.Folders)
    }
    
    func LoadFolders() {
        Folders = UserDefaultsManager.Shared.Load(ForKey: StringConstants.Folders) ?? []
    }
    
    func AddFolder() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            var Folder = FolderModel()
            Folder.CustomName = InputName
            Folders.insert(Folder, at: 0)
            SaveFolders()
        }
    }
    
    func AddButtonAction() {
        let Folder = FolderModel()
        InputName = Folder.Name
        ShowCreatedAlert = true
    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedFolders.removeAll()
        }
    }
    
    func FavoritesButtonAction() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if OnlyShowFavorites {
                OnlyShowFavorites.toggle()
                LoadFolders()
            } else {
                Folders = FavoriteFolders
                OnlyShowFavorites.toggle()
            }
        }
    }
    
    func SelectionCountText(For Count: Int) -> String {
        switch Count {
        case 0:
            return StringConstants.SelectItems
        case 1:
            return StringConstants.OneFolderSelected
        default:
            return String(format: StringConstants.MultipleFoldersSelected, Count)
        }
    }
    
    var PinnedFolders: [FolderModel] {
        return Folders.filter { $0.IsPinned }
    }
    
    func PinActionLabel(For Name: String) -> String {
        return Folders.contains { $0.Name == Name && $0.IsPinned } ? StringConstants.ContextMenu.Unpin.Text : StringConstants.ContextMenu.Pin.Text
    }
    
    func PinFolder(For Folder: FolderModel) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders[Index].IsPinned.toggle()
                SaveFolders()
            }
        }
    }
    
    func ToggleFavorite(For Folder: FolderModel) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders[Index].IsFavorite.toggle()
                SaveFolders()
            }
        }
    }
    
    func RenameFolder(NewName: String) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Folder = FolderToRename, let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                Folders[Index].CustomName = NewName
                SaveFolders()
                FolderToRename = nil
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
    
    func circleOffset(for itemWidth: CGFloat, xOffsetValue: CGFloat = 20, yOffsetValue: CGFloat = 20) -> (x: CGFloat, y: CGFloat) {
        let x = (itemWidth / 2) - xOffsetValue
        let y = -(itemWidth * 1.5 / 2) + yOffsetValue
        return (x, y)
    }
    
    func AddFolderWithAssetVideo() {
        let TodayFolders = TodayFolders

        if let LatestFolder = TodayFolders.first {
            var UpdatedFolder = LatestFolder
            var NewVideo = VideoModel()
            NewVideo.AssetVideoName = "LVS"
            if UpdatedFolder.Videos != nil {
                UpdatedFolder.Videos?.append(NewVideo)
            } else {
                UpdatedFolder.Videos = [NewVideo]
            }
            if let Index = Folders.firstIndex(where: { $0.id == UpdatedFolder.id }) {
                Folders[Index] = UpdatedFolder
            }
        } else {
            var NewFolder = FolderModel()
            var NewVideo = VideoModel()
            NewVideo.AssetVideoName = "LVS"
            NewFolder.Videos = [NewVideo]
            Folders.insert(NewFolder, at: 0)
        }
        SaveFolders()
    }
}
