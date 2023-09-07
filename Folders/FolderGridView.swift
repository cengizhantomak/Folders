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
            ForEach(Folders) { Folder in
                FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
                    .onTapGesture {
                        if ViewModel.IsSelecting {
                            if ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) {
                                if let Index = ViewModel.SelectedFolders.firstIndex(where: { $0.id == Folder.id }) {
                                    ViewModel.SelectedFolders.remove(at: Index)
                                }
                            } else {
                                ViewModel.SelectedFolders.append(Folder)
                            }
                        } else {
                            ViewModel.RemoveFolder(For: Folder)
                        }
                    }
                    .opacity(ViewModel.IsSelecting && !ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0)
            }
        }
    }
}

struct FolderGridView_Previews: PreviewProvider {
    static var previews: some View {
        FolderGridView(ViewModel: FolderViewModel(), Folders: [FolderModel.init(Name: "Okan Tel"), FolderModel.init(Name: "Muhittin ")], ItemWidth: 150)
    }
}
