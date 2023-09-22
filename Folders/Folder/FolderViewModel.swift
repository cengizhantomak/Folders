//
//  FolderViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI
import LVRealmKit

class FolderViewModel: ObservableObject {
    //    @Published var Folders: [FolderModel] = []
    //    @Published var SelectedFolders: [FolderModel] = []
    @Published var Columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Published var IsSelecting = false
    //    @Published var OnlyShowFavorites = false
    //    @Published var ShowBottomBarDeleteAlert = false
    //    @Published var ShowCreatedAlert = false
    //    @Published var ShowRenameAlert = false
    //    @Published var ShowDeleteAlert = false
    //    @Published var NewName = ""
    //    @Published var Folder: FolderModel?
    //    @Published var IsSuccessTTProgressHUDVisible = false
    //    @Published var IsErrorTTProgressHUDVisible = false
    //    @Published var FolderName = ""
    //    var FolderCreationDate = Date()
    @Published var Sessions: [SessionModel] = []
    @Published var SelectedSessions: [SessionModel] = []
    
    init() {
        LoadFolders()
    }
    
    private func UpdateSessionModel(SessionModel: [SessionModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Sessions = SessionModel
            }
        }
    }
    
    func LoadFolders() {
        Task {
            do {
                let AllSessions = try await FolderRepository.shared.getFolders()
                UpdateSessionModel(SessionModel: AllSessions)
            } catch {
                print("Error loading sessions: \(error)")
            }
        }
    }
    
    func AddFolder(_ Folder: SessionModel) {
        Task {
            do {
                try await FolderRepository.shared.addFolder(Folder)
                LoadFolders()
            } catch {
                print("Error adding session: \(error)")
            }
        }
    }
    
    func DeleteFolders(_ Folder: SessionModel) {
        Task {
            do {
                try await FolderRepository.shared.deleteFolders([Folder])
                LoadFolders()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
    }
    
    var TodaySection: [SessionModel] {
        let Today = Date()
        return Sessions.filter {
            Calendar.current.isDate($0.createdAt, inSameDayAs: Today) && !$0.isPinned
        }
    }
    
    var SessionSection: [SessionModel] {
        let Session = Date()
        return Sessions.filter {
            !Calendar.current.isDate($0.createdAt, inSameDayAs: Session) && !$0.isPinned
        }
    }
    
//    var FavoriteFolders: [FolderModel] {
//        return Folders.filter { $0.IsFavorite }
//    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - (Padding * (Amount + 1))) / Amount
    }
    
//    func SaveFolders() {
//        UserDefaultsManager.Shared.Save(Folders, ForKey: StringConstants.Folders)
//    }
//
//    func AddButtonAction() {
//        FolderCreationDate = Date()
//        FolderName = FolderCreationDate.CurrentDateTime()
//        ShowCreatedAlert = true
//    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedSessions.removeAll()
        }
    }
    
//    func FavoritesButtonAction() {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            if self.OnlyShowFavorites {
//                self.OnlyShowFavorites.toggle()
//                self.LoadFolders()
//            } else {
//                self.Folders = self.FavoriteFolders
//                self.OnlyShowFavorites.toggle()
//            }
//        }
//    }
    
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
    
//    var PinnedFolders: [FolderModel] {
//        return Folders.filter { $0.IsPinned }
//    }
    
//    func PinActionLabel(For Name: String) -> String {
//        return Folders.contains { $0.Name == Name && $0.IsPinned } ? StringConstants.ContextMenu.Unpin.Text : StringConstants.ContextMenu.Pin.Text
//    }
    
//    func PinFolder() {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            if let Folder = self.Folder,
//               let Index = self.Folders.firstIndex(where: { $0.id == Folder.id }) {
//                self.Folders[Index].IsPinned.toggle()
//                self.SaveFolders()
//                self.Folder = nil
//            }
//
//            self.IsSuccessTTProgressHUDVisible = true
//        }
//    }
    
//    func ToggleFavorite() {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            if let Folder = self.Folder,
//               let Index = self.Folders.firstIndex(where: { $0.id == Folder.id }) {
//                self.Folders[Index].IsFavorite.toggle()
//                self.SaveFolders()
//                self.Folder = nil
//            }
//
//            self.IsSuccessTTProgressHUDVisible = true
//        }
//    }
    
//    func RenameFolder(NewName: String) {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            if let Folder = self.Folder,
//               let Index = self.Folders.firstIndex(where: { $0.id == Folder.id }) {
//                self.Folders[Index].Name = NewName
//                self.SaveFolders()
//                self.Folder = nil
//            }
//
//            self.IsSuccessTTProgressHUDVisible = true
//        }
//    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (1970 / 1080) / 2) + YOffsetValue
        return (X, Y)
    }
    
//    func AddFolderWithAssetVideo() {
//        let TodayFolders = TodayFolders
//        
//        if let LatestFolder = TodayFolders.first {
//            var UpdatedFolder = LatestFolder
//            var NewVideo = VideoModel()
//            NewVideo.AssetVideoName = "LVS"
//            
//            if UpdatedFolder.Videos != nil {
//                UpdatedFolder.Videos?.append(NewVideo)
//            } else {
//                UpdatedFolder.Videos = [NewVideo]
//            }
//            
//            if let Index = Folders.firstIndex(where: { $0.id == UpdatedFolder.id }) {
//                Folders[Index] = UpdatedFolder
//            }
//        } else {
//            var NewFolder = FolderModel()
//            var NewVideo = VideoModel()
//            NewVideo.AssetVideoName = "LVS"
//            NewFolder.Videos = [NewVideo]
//            Folders.insert(NewFolder, at: 0)
//        }
//        
//        SaveFolders()
//        IsSuccessTTProgressHUDVisible = true
//    }
}
