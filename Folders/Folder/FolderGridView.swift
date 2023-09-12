//
//  FolderGridView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 7.09.2023.
//

import SwiftUI

struct FolderGridView: View {
    @StateObject var ViewModel: FolderViewModel
    var Folders: [FolderModel]
    var ItemWidth: CGFloat
    
    var body: some View {
        LazyVGrid(columns: ViewModel.Columns, spacing: 10) {
            ForEach(Folders.sorted(by: { $0.CreationDate > $1.CreationDate })) { Folder in
                if ViewModel.IsSelecting {
                    FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
                        .onTapGesture {
                            if ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) {
                                if let Index = ViewModel.SelectedFolders.firstIndex(where: { $0.id == Folder.id }) {
                                    ViewModel.SelectedFolders.remove(at: Index)
                                }
                            } else {
                                ViewModel.SelectedFolders.append(Folder)
                            }
                        }
                        .opacity(ViewModel.IsSelecting && !ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0)
                } else {
                    NavigationLink(destination: VideoView(ViewModel: VideoViewModel(Folder: Folder))) {
                        FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
                    }
                    .foregroundColor(.primary)
                }
            }
        }
    }
}

struct FolderGridView_Previews: PreviewProvider {
    static var previews: some View {
        FolderGridView(ViewModel: FolderViewModel(), Folders: [FolderModel.init(Name: "LVS"), FolderModel.init(Name: "RnD")], ItemWidth: 150)
    }
}
