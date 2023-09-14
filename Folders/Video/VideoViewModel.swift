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
    @Published var InputName: String = ""
    @Published var OnlyShowFavorites = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var NewName = ""
    @Published var VideoToRename: VideoModel?
    
    init(Folder: FolderModel) {
        self.Folder = Folder
        LoadVideos()
    }
    
    var FavoriteVideos: [VideoModel] {
        return Videos.filter { $0.IsFavorite }
    }
    
    func SaveUpdatedFolder() {
        var savedFolders: [FolderModel] = UserDefaultsManager.Shared.Load(ForKey: StringConstants.Folders) ?? []
        
        guard let folderIndex = savedFolders.firstIndex(where: { $0.id == Folder.id }) else {
            return
        }
        
        savedFolders[folderIndex] = Folder
        UserDefaultsManager.Shared.Save(savedFolders, ForKey: StringConstants.Folders)
    }
    
    func LoadVideos() {
        guard let VideosFromFolder = Folder.Videos else {
            return
        }
        Videos = VideosFromFolder
    }
    
    func FavoritesButtonAction() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
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
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            guard let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Videos[VideoIndex].IsFavorite.toggle()
            
            guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
                return
            }
            
            Folder.Videos?[FolderVideoIndex] = Videos[VideoIndex]
            SaveUpdatedFolder()
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
        guard let VideoIndex = Videos.firstIndex(where: { $0.id == Video.id }) else {
            return
        }
        
        Videos.remove(at: VideoIndex)
        
        guard let FolderVideoIndex = Folder.Videos?.firstIndex(where: { $0.id == Video.id }) else {
            return
        }
        
        Folder.Videos?.remove(at: FolderVideoIndex)
        SaveUpdatedFolder()
    }
    
    func RenameVideo(NewName: String) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
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
        }
    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * 16/9 / 2) + YOffsetValue
        return (X, Y)
    }
}
