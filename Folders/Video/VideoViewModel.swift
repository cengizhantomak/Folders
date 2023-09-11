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
    
    init(Folder: FolderModel) {
        self.Folder = Folder
        LoadVideos()
    }
    
    func SaveVideos() {
        if let Encoded = try? JSONEncoder().encode(Videos) {
            UserDefaults.standard.setValue(Encoded, forKey: StringConstants.Videos)
        }
    }
    
    func LoadVideos() {
        if let Data = UserDefaults.standard.data(forKey: StringConstants.Videos),
           let Decoded = try? JSONDecoder().decode([VideoModel].self, from: Data) {
            Videos = Decoded
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
    
    func AddVideo() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Videos.insert(VideoModel(), at: 0)
            SaveVideos()
        }
    }
    
    func RemoveVideo(For Video: VideoModel) {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            if let Index = Videos.firstIndex(where: { $0.id == Video.id }) {
                Videos.remove(at: Index)
                SaveVideos()
            }
        }
    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * 1.5 / 2) + YOffsetValue
        return (X, Y)
    }
}
