//
//  VideoViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

class VideoViewModel: ObservableObject {
    @Published var Folder: FolderModel
    @Published var Videos: [VideoModel] = []
    @Published var SelectedVideos: [VideoModel] = []
    @Published var Columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var IsSelecting = false
    @Published var ShowBottomBarDeleteAlert = false
    @Published var InputName = ""
    @Published var OnlyShowFavorites = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var NewName = ""
    @Published var VideoToRename: VideoModel?
    @Published var IsTTProgressHUDVisible = false
    
    init(Folder: FolderModel) {
        self.Folder = Folder
        LoadVideos()
    }
    
    var FavoriteVideos: [VideoModel] {
        return Videos.filter { $0.IsFavorite }
    }
    
    func SaveUpdatedFolder() {
        var SavedFolders: [FolderModel] = UserDefaultsManager.Shared.Load(ForKey: StringConstants.Folders) ?? []
        
        guard let FolderIndex = SavedFolders.firstIndex(where: { $0.id == Folder.id }) else {
            return
        }
        
        SavedFolders[FolderIndex] = Folder
        UserDefaultsManager.Shared.Save(SavedFolders, ForKey: StringConstants.Folders)
    }
    
    func LoadVideos() {
        guard let VideosFromFolder = Folder.Videos else {
            return
        }
        Videos = VideosFromFolder
    }
    
    func FavoritesButtonAction() {
        withAnimation(.spring()) {
            if OnlyShowFavorites {
                OnlyShowFavorites.toggle()
                LoadVideos()
            } else {
                Videos = FavoriteVideos
                OnlyShowFavorites.toggle()
            }
        }
    }
    
    func ToggleFavorite(For Video: VideoModel) {
        withAnimation(.spring()) {
            guard let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Videos[VideoIndex].IsFavorite.toggle()
            
            guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Folder.Videos?[FolderVideoIndex] = Videos[VideoIndex]
            SaveUpdatedFolder()
            ShowTTProgressHUD()
        }
    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedVideos.removeAll()
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
    
    func RemoveVideo(For Video: VideoModel) {
        withAnimation(.spring()) {
            guard let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Videos.remove(at: VideoIndex)
            
            guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Folder.Videos?.remove(at: FolderVideoIndex)
            SaveUpdatedFolder()
            ShowTTProgressHUD()
        }
    }
    
    func SaveToPhone() {
        print("Save to Phone Tapped")
        ShowTTProgressHUD()
    }
    
    func RenameVideo(NewName: String) {
        withAnimation(.spring()) {
            guard let Video = VideoToRename,
                  let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Videos[VideoIndex].CustomName = NewName
            
            guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Folder.Videos?[FolderVideoIndex] = Videos[VideoIndex]
            SaveUpdatedFolder()
            VideoToRename = nil
            ShowTTProgressHUD()
        }
    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (16 / 9) / 2) + YOffsetValue
        return (X, Y)
    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - Padding) / Amount
    }
    
    func ShowTTProgressHUD() {
        IsTTProgressHUDVisible = true
        
        DispatchQueue.global().async {
            sleep(1)
            
            DispatchQueue.main.async { [weak self] in
                self?.IsTTProgressHUDVisible = false
            }
        }
    }
}
