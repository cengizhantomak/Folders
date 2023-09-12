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
            .contextMenu {
                VideoContextMenu
            }
//            .alert(isPresented: $ViewModel.ShowDeleteAlert) {
//                Alert(
//                    title: Text(StringConstants.Alert.Title.Deleting),
//                    message: Text(StringConstants.Alert.Message.DeleteConfirmationMessage),
//                    primaryButton: .destructive(Text(StringConstants.Alert.ButtonText.Delete)) {
//                        ViewModel.RemoveVideo(For: Video)
//                    },
//                    secondaryButton: .cancel()
//                )
//            }
            .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowDeleteAlert) {
                Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
                Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                    ViewModel.RemoveVideo(For: Video)
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Cancel Tapped")
                }
            }
            .alert(StringConstants.Alert.Title.RenameVideo, isPresented: $ViewModel.ShowRenameAlert) {
                TextField(StringConstants.Alert.Title.VideoName, text: $ViewModel.NewName)
                Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                    if !ViewModel.NewName.isEmpty {
                        ViewModel.RenameVideo(NewName: ViewModel.NewName)
                    }
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    ViewModel.NewName = Video.Name
                    print("Cancel Tapped")
                }
            }
    }
    
    private var VideoItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 20, YOffsetValue: 20)
        let SafeItemWidth = max(ItemWidth, 1)
        
        return ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: SafeItemWidth, height: SafeItemWidth * 16/9)
                .cornerRadius(2)
            Image(systemName: StringConstants.SystemImage.Play)
                .resizable()
                .scaledToFit()
                .frame(width: SafeItemWidth * 0.3, height: SafeItemWidth * 0.3)
                .foregroundColor(Color.gray)
            VStack(alignment: .leading) {
                Spacer()
                Text(Video.Name)
                    .font(.system(size: 7))
                    .padding(10)
            }
            if Video.IsFavorite && !ViewModel.IsSelecting {
                Image(systemName: StringConstants.SystemImage.HeartFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SafeItemWidth * 0.08, height: SafeItemWidth * 0.08)
                    .foregroundColor(.red)
                    .offset(x: CircleOffset.X, y: CircleOffset.Y)
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
    
    private var VideoContextMenu: some View {
        VStack {
            Button {
                ViewModel.ToggleFavorite(For: Video)
            } label: {
                Label(
                    Video.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                    systemImage: Video.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
                )
            }
            Button {
                print("Save to Phone Tapped")
            } label: {
                Label(
                    StringConstants.ContextMenu.SaveToPhone.Text,
                    systemImage: StringConstants.ContextMenu.SaveToPhone.SystemImage
                )
            }
            Divider()
            Button {
                ViewModel.VideoToRename = Video
                ViewModel.NewName = Video.Name
                ViewModel.ShowRenameAlert = true
            } label: {
                Label(
                    StringConstants.ContextMenu.Rename.Text,
                    systemImage: StringConstants.ContextMenu.Rename.SystemImage
                )
            }
            Button(role: .destructive) {
                ViewModel.ShowDeleteAlert = true
            } label: {
                Label(
                    StringConstants.ContextMenu.Delete.Text,
                    systemImage: StringConstants.ContextMenu.Delete.SystemImage
                )
            }
        }
    }
}

struct VideoItemView_Previews: PreviewProvider {
    static var previews: some View {
        VideoItemView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), Video: VideoModel(), ItemWidth: 100)
    }
}
