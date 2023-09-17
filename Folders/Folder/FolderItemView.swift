//
//  FolderItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct FolderItemView: View {
    @StateObject var ViewModel: FolderViewModel
    var Folder: FolderModel
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
            Text(Folder.Name)
                .font(.system(size: 15))
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
    
    // MARK: - FolderItem
    private var FolderItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 20, YOffsetValue: 20)
        let SafeItemWidth = max(ItemWidth, 1)
        
        return ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: ItemWidth, height: ItemWidth * 1.5)
                .cornerRadius(10)
            Image(systemName: StringConstants.SystemImage.RectangleStackBadgePlay)
                .resizable()
                .scaledToFit()
                .frame(width: ItemWidth * 0.3, height: ItemWidth * 0.3)
                .foregroundColor(.gray)
            FavoriteIcon(CircleOffset: CircleOffset, SafeItemWidth: SafeItemWidth)
            SelectionIcon(CircleOffset: CircleOffset)
        }
    }
    
    // MARK: - Icons
    private func FavoriteIcon(CircleOffset: (X: CGFloat, Y: CGFloat), SafeItemWidth: CGFloat) -> some View {
        Group {
            if Folder.IsFavorite && !ViewModel.IsSelecting {
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
                        ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ?
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
            ViewModel.PinFolder(For: Folder)
        } label: {
            Label(
                ViewModel.Folders.contains { $0.Name == Folder.Name && $0.IsPinned } ? StringConstants.ContextMenu.Unpin.Text : StringConstants.ContextMenu.Pin.Text,
                systemImage: Folder.IsPinned ? StringConstants.ContextMenu.Unpin.SystemImage : StringConstants.ContextMenu.Pin.SystemImage
            )
        }
    }
    
    private var ToggleFavoriteButton: some View {
        Button {
            ViewModel.ToggleFavorite(For: Folder)
        } label: {
            Label(
                Folder.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                systemImage: Folder.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
            )
        }
    }
    
    private var RenameVideoButton: some View {
        Button {
            ViewModel.FolderToRename = Folder
            ViewModel.NewName = Folder.Name
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
            TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameFolder(NewName: ViewModel.NewName)
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
                ViewModel.RemoveFolder(For: Folder)
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
}

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(ViewModel: FolderViewModel(), Folder: FolderModel(Name: "LVS"), ItemWidth: 100)
    }
}
