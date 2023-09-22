//
//  FolderGridView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 7.09.2023.
//

import SwiftUI
import LVRealmKit

struct FolderGridView: View {
    @StateObject var ViewModel: FolderViewModel
    var Folders: [SessionModel]
    var ItemWidth: CGFloat
    
    var body: some View {
        LazyVGrid(columns: ViewModel.Columns, spacing: 10) {
            ForEach(ViewModel.Sessions, id: \.self) { Folder in
                if !ViewModel.IsSelecting {
                    NavigatableView(For: Folder)
                } else {
                    SelectableFolderItem(For: Folder)
                }
            }
        }
    }
    
    // MARK: Navigation Link
    private func NavigatableView(For Folder: SessionModel) -> some View {
//        NavigationLink(destination: VideoView(ViewModel: VideoViewModel(Folder: Folder))) {
            FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
//        }
//        .foregroundColor(.primary)
    }
    
    // MARK: Selectable Folder Item
    private func SelectableFolderItem(For Folder: SessionModel) -> some View {
        FolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
            .onTapGesture {
                HandleFolderSelection(Of: Folder)
            }
            .opacity(Opacity(For: Folder))
    }
    
    // MARK: Selection Handling
    private func HandleFolderSelection(Of Folder: SessionModel) {
        if let Index = ViewModel.SelectedSessions.firstIndex(where: { $0.id == Folder.id }) {
            ViewModel.SelectedSessions.remove(at: Index)
        } else {
            ViewModel.SelectedSessions.append(Folder)
        }
    }
    
    // MARK: Folder Opacity
    private func Opacity(For Folder: SessionModel) -> Double {
        return ViewModel.IsSelecting && !ViewModel.SelectedSessions.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0
    }
}

//struct FolderGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderGridView(ViewModel: FolderViewModel(), Folders: [FolderModel.init(Name: "LVS"), FolderModel.init(Name: "RnD")], ItemWidth: 150)
//    }
//}
