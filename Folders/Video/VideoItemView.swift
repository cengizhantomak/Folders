//
//  VideoItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct VideoItemView: View {
    @StateObject var ViewModel: VideoViewModel
    var Video: VideoModel
    let ItemWidth: CGFloat
    
    var body: some View {
        VideoItem
    }
    
    private var VideoItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 18, YOffsetValue: 1)
        
        return ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: ItemWidth, height: ItemWidth * 16/9)
                .cornerRadius(2)
            Image(systemName: "play")
                .resizable()
                .scaledToFit()
                .frame(width: ItemWidth * 0.3, height: ItemWidth * 0.3)
                .foregroundColor(Color.gray)
            VStack(alignment: .leading) {
                Spacer()
                Text(Video.Name)
                    .font(.system(size: 7))
                    .padding(10)
            }
            if ViewModel.IsSelecting {
                Circle()
                    .stroke(.gray, lineWidth: 2)
                    .background(Circle().fill(Color.white))
                    .overlay(
                        ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) ?
                        Circle().stroke(.gray, lineWidth: 2).frame(width: 10, height: 10) : nil
                    )
                    .frame(width: 20, height: 20)
                    .offset(x: CircleOffset.X, y: CircleOffset.Y)
            }
        }
    }
}

struct VideoItemView_Previews: PreviewProvider {
    static var previews: some View {
        VideoItemView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), Video: VideoModel(), ItemWidth: 100)
    }
}
