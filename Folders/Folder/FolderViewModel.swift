//
//  FolderViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI
import LVRealmKit

class FolderViewModel: ObservableObject {
    var Columns = [GridItem(.flexible()), GridItem(.flexible())]
    @Published var IsSelecting = false
    @Published var OnlyShowFavorites = false
    @Published var ShowBottomBarDeleteAlert = false
    @Published var ShowCreatedAlert = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var IsSuccessTTProgressHUDVisible = false
    @Published var IsErrorTTProgressHUDVisible = false
    @Published var SelectedSessions: [SessionModel] = []
    @Published var Session: SessionModel?
    @Published var FolderName = ""
    @Published var NewName = ""
    var FolderCreationDate: Date?
    var TodaySection: [SessionModel] = []
    var SessionSection: [SessionModel] = []
    var PinnedSection: [SessionModel] = []
    var Sessions: [SessionModel] = [] {
        didSet {
            self.TodaySection = Sessions.filter {
                Calendar.current.isDate($0.createdAt, inSameDayAs: Date()) && !$0.isPinned
            }
            self.SessionSection = Sessions.filter {
                        !Calendar.current.isDate($0.createdAt, inSameDayAs: Date()) && !$0.isPinned
                    }
            self.PinnedSection = Sessions.filter { $0.isPinned }
        }
    }
    
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
    
    private func SuccessTTProgressHUD() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.IsSuccessTTProgressHUDVisible = true
        }
    }
    
    func ErrorTTProgressHUD() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.IsErrorTTProgressHUDVisible = true
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
                SuccessTTProgressHUD()
            } catch {
                print("Error adding session: \(error)")
            }
        }
    }
    
    func AddPractice() {
        Task {
            do {
                if let LastFolder = try? await FolderRepository.shared.getLastFolder() {
                    var NewPractice = PracticeModel(id: "",
                                                    Name: Date().dateFormat("yyyyMMddHHmmssSSS"),
                                                    VideoPath: "LVS")
                    NewPractice.Session = LastFolder
                    _ = try await PracticeRepository.shared.addPractice(&NewPractice)
                }
                LoadFolders()
                SuccessTTProgressHUD()
            } catch {
                print("Failed to add practice: \(error)")
            }
        }
    }
    
    func RenameFolder(NewName: String) {
        Task {
            do {
                if var Folder = Session {
                    Folder.name = NewName
                    try await FolderRepository.shared.edit(Folder)
                }
                LoadFolders()
                SuccessTTProgressHUD()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func DeleteFolders(_ Folder: [SessionModel]) {
        Task {
            do {
                try await FolderRepository.shared.deleteFolders(Folder)
                LoadFolders()
                SuccessTTProgressHUD()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
        SelectedSessions.removeAll()
    }
    
    func TogglePin() {
        Task {
            do {
                if var Folder = Session {
                    Folder.isPinned.toggle()
                    try await FolderRepository.shared.edit(Folder)
                }
                LoadFolders()
                SuccessTTProgressHUD()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func FavoritesButtonAction() {
        if OnlyShowFavorites {
            OnlyShowFavorites.toggle()
            LoadFolders()
            SuccessTTProgressHUD()
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
                SuccessTTProgressHUD()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
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
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - (Padding * (Amount + 1))) / Amount
    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (1970 / 1080) / 2) + YOffsetValue
        return (X, Y)
    }
    
    func Opacity(For Folder: SessionModel) -> Double {
        return IsSelecting && !SelectedSessions.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0
    }
}
