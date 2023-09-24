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
//    @Published var OnlyShowFavorites = false
//    @Published var ShowRenameAlert = false
//    @Published var ShowDeleteAlert = false
//    @Published var NewName = ""
//    @Published var Video: VideoModel?
//    @Published var IsSuccessTTProgressHUDVisible = false
//    @Published var IsErrorTTProgressHUDVisible = false
    @Published var Session: SessionModel
    @Published var Practices: [PracticeModel] = []
    @Published var SelectedPractices: [PracticeModel] = []
    
    init(Folder: SessionModel) {
        self.Session = Folder
        LoadPractices(For: Session)
    }
    
    private func UpdatePracticeModel(PracticeModel: [PracticeModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Practices = PracticeModel
            }
        }
    }
    
    func LoadPractices(For Session: SessionModel) {
        Task {
            do {
                let AllPractices = try await PracticeRepository.shared.getPractices(Session)
                UpdatePracticeModel(PracticeModel: AllPractices)
            } catch {
                print("Failed to load practices: \(error)")
            }
        }
    }
    
//    var FavoriteVideos: [VideoModel] {
//        return Videos.filter { $0.IsFavorite }
//    }
    
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
    
//    func FavoritesButtonAction() {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            if self.OnlyShowFavorites {
//                self.OnlyShowFavorites.toggle()
//                self.LoadVideos()
//            } else {
//                self.Videos = self.FavoriteVideos
//                self.OnlyShowFavorites.toggle()
//            }
//        }
//    }
    
//    func ToggleFavorite() {
//        guard let Video = Video,
//              let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
//            return
//        }
//        
//        Videos[VideoIndex].IsFavorite.toggle()
//        
//        guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
//            return
//        }
//        
//        Folder.Videos?[FolderVideoIndex] = Videos[VideoIndex]
//        SaveUpdatedFolder()
//        self.Video = nil
//        IsSuccessTTProgressHUDVisible = true
//    }
    
//    func SelectCancelButtonAction() {
//        IsSelecting.toggle()
//        if !IsSelecting {
//            SelectedVideos.removeAll()
//        }
//    }
    
//    func SelectionCount(For Count: Int) -> String {
//        switch Count {
//        case 0:
//            return StringConstants.SelectItems
//        case 1:
//            return StringConstants.OneVideoSelected
//        default:
//            return String(format: StringConstants.MultipleVideosSelected, Count)
//        }
//    }
    
//    func RemoveVideo() {
//        withAnimation(.spring()) { [weak self] in
//            guard let self else { return }
//            guard let Video = self.Video,
//                  let VideoIndex = self.Videos.firstIndex(where: { $0.id == Video.id }) else {
//                return
//            }
//            
//            self.Videos.remove(at: VideoIndex)
//            
//            guard let FolderVideoIndex = self.Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
//                return
//            }
//            
//            self.Folder.Videos?.remove(at: FolderVideoIndex)
//            self.SaveUpdatedFolder()
//            self.Video = nil
//            self.IsSuccessTTProgressHUDVisible = true
//        }
//    }
    
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
