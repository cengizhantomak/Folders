//
//  VideoGridView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 12.09.2023.
//

import SwiftUI

struct VideoGridView: View {
    @StateObject var ViewModel: VideoViewModel
    let ItemWidth: CGFloat
    
    var body: some View {
        Section(header: DateHeader) {
            LazyVGrid(columns: ViewModel.Columns, spacing: 5) {
                ForEach(SortedVideos) { Video in
                    if !ViewModel.IsSelecting {
                        VideoItemView(ViewModel: ViewModel, Video: Video, ItemWidth: ItemWidth)
                    } else {
                        SelectableVideoItem(For: Video)
                    }
                }
            }
        }
    }
    
    // MARK: Date Header
    private var DateHeader: some View {
        Text(DateHelper.CurrentDate(From: ViewModel.Folder.CreationDate))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(.clear)
            .padding(.top)
    }
    
    // MARK: Video Sorting
    private var SortedVideos: [VideoModel] {
        ViewModel.Videos.sorted(by: { $0.CreationDate > $1.CreationDate })
    }
    
    // MARK: Selectable Video Item
    private func SelectableVideoItem(For Video: VideoModel) -> some View {
        VideoItemView(ViewModel: ViewModel, Video: Video, ItemWidth: ItemWidth)
            .onTapGesture {
                HandleVideoSelection(Of: Video)
            }
            .opacity(Opacity(For: Video))
    }
    
    // MARK: Selection Handling
    private func HandleVideoSelection(Of Video: VideoModel) {
        if let Index = ViewModel.SelectedVideos.firstIndex(where: { $0.id == Video.id }) {
            ViewModel.SelectedVideos.remove(at: Index)
        } else {
            ViewModel.SelectedVideos.append(Video)
        }
    }
    
    // MARK: Video Opacity
    private func Opacity(For Video: VideoModel) -> Double {
        return ViewModel.IsSelecting && !ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) ? 0.5 : 1.0
    }
}

struct VideoGridView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGridView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), ItemWidth: 150)
    }
}
