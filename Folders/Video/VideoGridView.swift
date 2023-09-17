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
        Section(header: Text(DateHelper.CurrentDate(From: ViewModel.Folder.CreationDate))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .background(.clear)
                    .padding(.top)) {
            LazyVGrid(columns: ViewModel.Columns, spacing: 5) {
                ForEach(ViewModel.Videos.sorted(by: { $0.CreationDate > $1.CreationDate })) { Video in
                    VideoItemView(ViewModel: ViewModel, Video: Video, ItemWidth: ItemWidth)
                        .onTapGesture {
                            if ViewModel.IsSelecting {
                                if ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) {
                                    if let Index = ViewModel.SelectedVideos.firstIndex(where: { $0.id == Video.id }) {
                                        ViewModel.SelectedVideos.remove(at: Index)
                                    }
                                } else {
                                    ViewModel.SelectedVideos.append(Video)
                                }
                            } else {
                                ViewModel.RemoveVideo(For: Video)
                            }
                        }
                        .opacity(ViewModel.IsSelecting && !ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) ? 0.5 : 1.0)
                }
            }
        }
    }
}

struct VideoGridView_Previews: PreviewProvider {
    static var previews: some View {
        VideoGridView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), ItemWidth: 150)
    }
}
