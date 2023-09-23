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
    @Published var OnlyShowFavorites = false
    //    @Published var ShowBottomBarDeleteAlert = false
    @Published var ShowCreatedAlert = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var NewName = ""
    //    @Published var Folder: FolderModel?
    //    @Published var IsSuccessTTProgressHUDVisible = false
    //    @Published var IsErrorTTProgressHUDVisible = false
    @Published var FolderName = ""
    var FolderCreationDate: Date?
    @Published var Sessions: [SessionModel] = []
    @Published var SelectedSessions: [SessionModel] = []
    @Published var Session: SessionModel?
    
    init() {
        LoadFolders()
    }
    
    private func UpdateSessionModel(SessionModel: [SessionModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Sessions = SessionModel
                self.Session = nil
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
    
    func AddButtonAction() {
        FolderCreationDate = Date()
        FolderName = FolderCreationDate?.dateFormat("yyyyMMdd-HHmmssSSS") ?? "lvs"
        ShowCreatedAlert = true
    }
    
    func AddFolder() {
        Task {
            do {
                var Folder = SessionModel()
                Folder.name = FolderName
                Folder.createdAt = FolderCreationDate ?? Date()
                try await FolderRepository.shared.addFolder(Folder)
                LoadFolders()
            } catch {
                print("Error adding session: \(error)")
            }
        }
    }
    
    func DeleteFolders(_ Folder: [SessionModel]) {
        Task {
            do {
                try await FolderRepository.shared.deleteFolders(Folder)
                LoadFolders()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
        SelectedSessions.removeAll()
    }
    
    func RenameFolder(NewName: String) {
        Task {
            do {
                if var Folder = Session {
                    Folder.name = NewName
                    try await FolderRepository.shared.edit(Folder)
                }
                LoadFolders()
            } catch {
                print("Error updating favorite status: \(error)")
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
    
    var PinnedSection: [SessionModel] {
        return Sessions.filter { $0.isPinned }
    }
    
    func TogglePin() {
        Task {
            do {
                if var Folder = Session {
                    Folder.isPinned.toggle()
                    try await FolderRepository.shared.edit(Folder)
                }
                LoadFolders()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func FavoritesButtonAction() {
        if OnlyShowFavorites {
            OnlyShowFavorites.toggle()
            LoadFolders()
        } else {
            withAnimation(.spring()) { [weak self] in
                guard let self else { return }
                self.Sessions = self.Sessions.filter { $0.isFavorite }
            }
            OnlyShowFavorites.toggle()
        }
    }

    func ToggleFavorite() {
        Task {
            do {
                if var Folder = Session {
                    Folder.isFavorite.toggle()
                    try await FolderRepository.shared.edit(Folder)
                }
                LoadFolders()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - (Padding * (Amount + 1))) / Amount
    }
    
//    func SaveFolders() {
//        UserDefaultsManager.Shared.Save(Folders, ForKey: StringConstants.Folders)
//    }
//
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedSessions.removeAll()
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
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (1970 / 1080) / 2) + YOffsetValue
        return (X, Y)
    }
    
    func AddFolderWithAssetVideo() {
        Task {
            do {
                if let lastFolder = try? await FolderRepository.shared.getLastFolder() {
                    var newPractice = PracticeModel(id: UUID().uuidString, Name: Date().dateFormat("yyyyMMddHHmmssSSS"), VideoPath: "LVS")
                    newPractice.Session = lastFolder
                    _ = try await PracticeRepository.shared.addPractice(&newPractice)
                } else {
                    print("No folder found.")
                }
            } catch {
                print("Failed to add practice: \(error)")
            }
        }
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
