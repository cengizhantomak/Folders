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
        if !ViewModel.IsSelecting {
            VideoItem
                .contextMenu {
                    VideoContextMenu
                }
                .alert(StringConstants.Alert.Title.RenameVideo, isPresented: $ViewModel.ShowRenameAlert) {
                    RenameVideoAlert
                }
                .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowDeleteAlert) {
                    DeleteVideoAlert
                } message: {
                    Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
                }
        } else {
            VideoItem
        }
    }
    
    // MARK: - VideoItem
    private var VideoItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 20, YOffsetValue: 20)
        let SafeItemWidth = max(ItemWidth, 1)
        
        return ZStack {
            Image(Video.AssetVideoName ?? StringConstants.SystemImage.RectangleStackBadgePlay)
                .resizable()
                .frame(width: SafeItemWidth, height: SafeItemWidth * (16 / 9))
                .scaledToFit()
            VStack {
                Spacer()
                LinearGradient(colors: [Color.black, Color.clear], startPoint: .bottom, endPoint: .top)
                    .frame(height: 150)
            }
            VideoNameAtBottom
            FavoriteIcon(CircleOffset: CircleOffset, SafeItemWidth: SafeItemWidth)
            SelectionIcon(CircleOffset: CircleOffset)
        }
    }
    
    private var VideoNameAtBottom: some View {
        VStack {
            Spacer()
            VStack(alignment: .leading) {
                Text(Video.Name)
                    .truncationMode(.tail)
                    .lineLimit(1)
                    .font(.system(size: 9, weight: .bold))
                    .foregroundColor(.white)
                Text(DateHelper.CurrentTime(From: Video.CreationDate))
                    .font(.system(size: 8))
                    .foregroundColor(.gray)
            }
            .padding(5)
        }
    }
    
    // MARK: - Icons
    private func FavoriteIcon(CircleOffset: (X: CGFloat, Y: CGFloat), SafeItemWidth: CGFloat) -> some View {
        Group {
            if Video.IsFavorite && !ViewModel.IsSelecting {
                Image(systemName: StringConstants.SystemImage.HeartFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SafeItemWidth * 0.08, height: SafeItemWidth * 0.08)
                    .foregroundColor(.red)
                    .offset(x: CircleOffset.X, y: CircleOffset.Y)
            } else {
                EmptyView()
            }
        }
    }
    
    private func SelectionIcon(CircleOffset: (X: CGFloat, Y: CGFloat)) -> some View {
        Group {
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
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Context Menu and Actions
    private var VideoContextMenu: some View {
        VStack {
            ToggleFavoriteButton
            SaveToPhoneButton
            Divider()
            RenameVideoButton
            DeleteVideoButton
        }
    }
    
    private var ToggleFavoriteButton: some View {
        Button {
            ViewModel.ToggleFavorite(For: Video)
        } label: {
            Label(
                Video.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                systemImage: Video.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
            )
        }
    }
    
    private var SaveToPhoneButton: some View {
        Button {
            ViewModel.SaveToPhone()
        } label: {
            Label(
                StringConstants.ContextMenu.SaveToPhone.Text,
                systemImage: StringConstants.ContextMenu.SaveToPhone.SystemImage
            )
        }
    }
    
    private var RenameVideoButton: some View {
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
    }
    
    private var DeleteVideoButton: some View {
        Button(role: .destructive) {
            ViewModel.ShowDeleteAlert = true
        } label: {
            Label(
                StringConstants.ContextMenu.Delete.Text,
                systemImage: StringConstants.ContextMenu.Delete.SystemImage
            )
        }
    }
    
    // MARK: - Alerts
    private var RenameVideoAlert: some View {
        Group {
            TextField(StringConstants.Alert.Title.VideoName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameVideo(NewName: ViewModel.NewName)
                }
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
    
    private var DeleteVideoAlert: some View {
        Group {
            Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                ViewModel.RemoveVideo(For: Video)
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
}

struct VideoItemView_Previews: PreviewProvider {
    static var previews: some View {
        VideoItemView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")), Video: VideoModel(), ItemWidth: 100)
    }
}
