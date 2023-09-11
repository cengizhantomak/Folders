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
    @Published var Columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var InputName: String = ""
    
    init(Folder: FolderModel) {
        self.Folder = Folder
    }
    
    func AddVideo() {
        withAnimation(Animation.easeInOut(duration: 0.2)) {
            Videos.insert(VideoModel(), at: 0)
        }
    }
    
    func RemoveVideo(WithId Id: UUID) {
        if let Index = Videos.firstIndex(where: { $0.id == Id }) {
            Videos.remove(at: Index)
        }
    }
}
