//
//  VideoViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import LVRealmKit

class VideoViewModel: ObservableObject {
//    @Published var Folder: FolderModel
//    @Published var Videos: [VideoModel] = []
//    @Published var SelectedVideos: [VideoModel] = []
    @Published var Columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var IsSelecting = false
//    @Published var ShowBottomBarDeleteAlert = false
    @Published var OnlyShowFavorites = false
//    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
//    @Published var NewName = ""
//    @Published var Video: VideoModel?
//    @Published var IsSuccessTTProgressHUDVisible = false
//    @Published var IsErrorTTProgressHUDVisible = false
    @Published var Session: SessionModel
    @Published var Practices: [PracticeModel] = []
    @Published var SelectedPractices: [PracticeModel] = []
    @Published var Practice: PracticeModel?
    
    init(Folder: SessionModel) {
        self.Session = Folder
        LoadPractices()
    }
    
    private func UpdatePracticeModel(PracticeModel: [PracticeModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Practices = PracticeModel
                self.Practice = nil
            }
        }
    }
    
    func LoadPractices() {
        Task {
            do {
                let AllPractices = try await PracticeRepository.shared.getPractices(Session)
                UpdatePracticeModel(PracticeModel: AllPractices)
            } catch {
                print("Failed to load practices: \(error)")
            }
        }
    }
    
    func DeletePractices(_ Practice: [PracticeModel]) {
        Task {
            do {
                try await PracticeRepository.shared.deletePractices(Practice)
                LoadPractices()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
        SelectedPractices.removeAll()
    }
    
    func FavoritesButtonAction() {
        if OnlyShowFavorites {
            OnlyShowFavorites.toggle()
            LoadPractices()
        } else {
            withAnimation(.spring()) { [weak self] in
                guard let self else { return }
                self.Practices = self.Practices.filter { $0.isFavorite }
            }
            OnlyShowFavorites.toggle()
        }
    }

    func ToggleFavorite() {
        Task {
            do {
                if var Video = Practice {
                    Video.isFavorite.toggle()
                    try await PracticeRepository.shared.edit(Video)
                }
                LoadPractices()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
//    func SaveUpdatedFolder() {
//        var SavedFolders: [FolderModel] = UserDefaultsManager.Shared.Load(ForKey: StringConstants.Folders) ?? []
//        
//        guard let FolderIndex = SavedFolders.firstIndex(where: { $0.id == Folder.id }) else {
//            return
//        }
//        
//        SavedFolders[FolderIndex] = Folder
//        UserDefaultsManager.Shared.Save(SavedFolders, ForKey: StringConstants.Folders)
//    }
    
//    func LoadVideos() {
//        guard let VideosFromFolder = Folder.Videos else {
//            return
//        }
//        Videos = VideosFromFolder
//    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedPractices.removeAll()
        }
    }
    
    func SelectionCount(For Count: Int) -> String {
        switch Count {
        case 0:
            return StringConstants.SelectItems
        case 1:
            return StringConstants.OneVideoSelected
        default:
            return String(format: StringConstants.MultipleVideosSelected, Count)
        }
    }
    
//    func SaveToPhone() {
//        print("Save to Phone Tapped")
//        IsSuccessTTProgressHUDVisible = true
//    }
    
//    func RenameVideo(NewName: String) {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            guard let Video = self.Video,
//                  let VideoIndex = self.Videos.firstIndex(where: { $0.id == Video.id }) else {
//                return
//            }
//            
//            self.Videos[VideoIndex].Name = NewName
//            
//            guard let FolderVideoIndex = self.Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
//                return
//            }
//            
//            self.Folder.Videos?[FolderVideoIndex] = self.Videos[VideoIndex]
//            self.SaveUpdatedFolder()
//            self.Video = nil
//            self.IsSuccessTTProgressHUDVisible = true
//        }
//    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (16 / 9) / 2) + YOffsetValue
        return (X, Y)
    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - (Padding * (Amount + 1))) / Amount
    }
}
