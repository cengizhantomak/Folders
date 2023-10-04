//
//  FolderItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI
import LVRealmKit

struct FolderItemView: View {
    @StateObject var ViewModel: FolderViewModel
    var Folder: SessionModel
    let ItemWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
            if !ViewModel.IsSelecting {
                FolderItem
                    .contextMenu {
                        FolderContextMenu
                    }
            } else {
                FolderItem
            }
            Text(Folder.name)
                .truncationMode(.tail)
                .lineLimit(1)
                .font(.system(size: 15))
            Text(String(Folder.practiceCount))
                .font(.system(size: 14))
                .foregroundColor(.gray)
        }
        .alert(StringConstants.Alert.Title.RenameFolder, isPresented: $ViewModel.ShowRenameAlert) {
            RenameVideoAlert
        }
        .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowDeleteAlert) {
            DeleteVideoAlert
        } message: {
            Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
        }
    }
}

extension FolderItemView {
    
    // MARK: - FolderItem
    private var FolderItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 20, YOffsetValue: 20)
        let SafeItemWidth = max(ItemWidth, 1)
        
        return ZStack {
            if let ThumbPath = Folder.thumbnail {
                Image(uiImage: UIImage(contentsOfFile: URL.documentsDirectory.appending(path: ThumbPath).path) ?? UIImage())
                    .resizable()
                    .frame(width: SafeItemWidth, height: SafeItemWidth * (1970 / 1080))
                    .scaledToFit()
                    .cornerRadius(10)
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: SafeItemWidth, height: SafeItemWidth * (1970 / 1080))
                    .cornerRadius(10)
                Image(systemName: StringConstants.SystemImage.RectangleStackBadgePlay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SafeItemWidth * 0.3, height: SafeItemWidth * 0.3)
                    .foregroundColor(.gray)
            }
            FavoriteIcon(CircleOffset: CircleOffset, SafeItemWidth: SafeItemWidth)
            SelectionIcon(CircleOffset: CircleOffset)
        }
    }
    
    // MARK: - Icons
    private func FavoriteIcon(CircleOffset: (X: CGFloat, Y: CGFloat), SafeItemWidth: CGFloat) -> some View {
        Group {
            if Folder.isFavorite && !ViewModel.IsSelecting {
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
                        ViewModel.SelectedSessions.contains(where: { $0.id == Folder.id }) ?
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
    private var FolderContextMenu: some View {
        VStack {
            PinUnpinButton
            ToggleFavoriteButton
            Divider()
            RenameVideoButton
            DeleteVideoButton
        }
    }
    
    private var PinUnpinButton: some View {
        Button {
            ViewModel.Session = Folder
            ViewModel.TogglePin()
        } label: {
            Label(
                Folder.isPinned ? StringConstants.ContextMenu.Unpin.Text : StringConstants.ContextMenu.Pin.Text,
                systemImage:
                    Folder.isPinned ? StringConstants.ContextMenu.Unpin.SystemImage : StringConstants.ContextMenu.Pin.SystemImage
            )
        }
    }
    
    private var ToggleFavoriteButton: some View {
        Button {
            ViewModel.Session = Folder
            ViewModel.ToggleFavorite()
        } label: {
            Label(
                Folder.isFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                systemImage:
                    Folder.isFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
            )
        }
    }
    
    private var RenameVideoButton: some View {
        Button {
            ViewModel.Session = Folder
            ViewModel.NewName = Folder.name
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
            ViewModel.SelectedSessions.append(Folder)
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
            TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameFolder(NewName: ViewModel.NewName)
                } else {
                    ViewModel.ErrorTTProgressHUD()
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
                ViewModel.DeleteFolders(ViewModel.SelectedSessions)
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                ViewModel.SelectedSessions.removeAll()
                print("Cancel Tapped")
            }
        }
    }
}

//struct FolderItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderItemView(ViewModel: FolderViewModel(), Folder: FolderModel(Name: "LVS"), ItemWidth: 100)
//    }
//}
