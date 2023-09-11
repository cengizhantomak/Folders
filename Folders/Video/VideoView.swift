//
//  VideoView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct VideoView: View {
    @StateObject var ViewModel: VideoViewModel
    
    var body: some View {
        GeometryReader { Geometry in
            let ScreenWidth = Geometry.size.width
            let ItemWidth = (ScreenWidth - 20) / 3
            ScrollView {
                LazyVGrid(columns: ViewModel.Columns, spacing: 5) {
                    ForEach(ViewModel.Videos.sorted(by: { $0.CreationDate > $1.CreationDate })) { Video in
                        VideoItemView(Video: Video, ItemWidth: ItemWidth)
                            .onTapGesture {
                                ViewModel.RemoveVideo(WithId: Video.id)
                            }
                    }
                }
                .padding(5)
            }
            .navigationTitle(ViewModel.Folder.Name)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: ViewModel.AddVideo) {
                        Image(systemName: "plus")
                            .foregroundColor(.black)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                    }
                }
            }
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")))
    }
}
