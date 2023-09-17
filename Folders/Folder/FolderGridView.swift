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
            ForEach(SortedFolders) { Folder in
                if !ViewModel.IsSelecting {
                    NavigatableView(For: Folder)
                } else {
                    SelectableFolderItem(For: Folder)
                }
            }
        }
    }
    
    // MARK: Folder Sorting
    private var SortedFolders: [FolderModel] {
        Folders.sorted(by: { $0.CreationDate > $1.CreationDate })
    }
    
    // MARK: Navigation Link
    private func NavigatableView(For Folder: FolderModel) -> some View {
        NavigationLink(destination: VideoView(ViewModel: VideoViewModel(Folder: Folder))) {
            FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
        }
        .foregroundColor(.primary)
    }
    
    // MARK: Selectable Folder Item
    private func SelectableFolderItem(For Folder: FolderModel) -> some View {
        FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
            .onTapGesture {
                HandleFolderSelection(Of: Folder)
            }
            .opacity(Opacity(For: Folder))
    }
    
    // MARK: Selection Handling
    private func HandleFolderSelection(Of Folder: FolderModel) {
        if let Index = ViewModel.SelectedFolders.firstIndex(where: { $0.id == Folder.id }) {
            ViewModel.SelectedFolders.remove(at: Index)
        } else {
            ViewModel.SelectedFolders.append(Folder)
        }
    }
    
    // MARK: Folder Opacity
    private func Opacity(For Folder: FolderModel) -> Double {
        return ViewModel.IsSelecting && !ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0
    }
}

struct FolderGridView_Previews: PreviewProvider {
    static var previews: some View {
        FolderGridView(ViewModel: FolderViewModel(), Folders: [FolderModel.init(Name: "LVS"), FolderModel.init(Name: "RnD")], ItemWidth: 150)
    }
}
