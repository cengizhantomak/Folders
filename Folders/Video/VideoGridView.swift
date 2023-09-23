//
//  VideoGridView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 12.09.2023.
//

import SwiftUI
import LVRealmKit

struct VideoGridView: View {
    @StateObject var ViewModel: VideoViewModel
    let ItemWidth: CGFloat
    
    var body: some View {
        Section(header: DateHeader) {
            LazyVGrid(columns: ViewModel.Columns, spacing: 1) {
                ForEach(ViewModel.Practices, id: \.self) { Video in
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
        Text(Date.CurrentDate(From: ViewModel.Session.createdAt))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(.clear)
            .padding(.top)
    }
    
    // MARK: Video Sorting
//    private var SortedVideos: [VideoModel] {
//        ViewModel.Videos.sorted(by: { $0.CreationDate > $1.CreationDate })
//    }
    
    // MARK: Selectable Video Item
    private func SelectableVideoItem(For Video: PracticeModel) -> some View {
        VideoItemView(ViewModel: ViewModel, Video: Video, ItemWidth: ItemWidth)
            .onTapGesture {
                HandleVideoSelection(Of: Video)
            }
            .opacity(Opacity(For: Video))
    }
    
    // MARK: Selection Handling
    private func HandleVideoSelection(Of Video: PracticeModel) {
        if let Index = ViewModel.SelectedPractices.firstIndex(where: { $0.id == Video.id }) {
            ViewModel.SelectedPractices.remove(at: Index)
        } else {
            ViewModel.SelectedPractices.append(Video)
        }
    }
    
    // MARK: Video Opacity
    private func Opacity(For Video: PracticeModel) -> Double {
        return ViewModel.IsSelecting && !ViewModel.SelectedPractices.contains(where: { $0.id == Video.id }) ? 0.5 : 1.0
    }
}

//struct VideoGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        VideoGridView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), ItemWidth: 150)
//    }
//}
