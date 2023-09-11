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
            FolderIcon
                .contextMenu {
                    FolderContextMenu
                }
            Text(Folder.Name)
                .font(.system(size: 15))
        }
        .onAppear {
            ViewModel.NewName = Folder.Name
        }
        .alert(StringConstants.Alert.Title.RenameFolder, isPresented: $ViewModel.ShowRenameAlert) {
            TextField(StringConstants.Alert.Title.RenameFolder, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameFolder(For: Folder, NewName: ViewModel.NewName)
                }
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                ViewModel.NewName = Folder.Name
                print("Cancel Tapped")
            }
        }
        .alert(isPresented: $ViewModel.ShowDeleteAlert) {
            Alert(
                title: Text(StringConstants.Alert.Title.Deleting),
                message: Text(StringConstants.Alert.Message.DeleteConfirmationMessage),
                primaryButton: .destructive(Text(StringConstants.Alert.ButtonText.Delete)) {
                    ViewModel.RemoveFolder(For: Folder)
                },
                secondaryButton: .cancel()
            )
        }
    }
    
    private var FolderIcon: some View {
        let CircleOffset = ViewModel.circleOffset(for: ItemWidth, xOffsetValue: 20, yOffsetValue: 20)
        
        return ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: ItemWidth, height: ItemWidth * 1.5)
                .cornerRadius(10)
            Image(systemName: "rectangle.stack.badge.play")
                .resizable()
                .scaledToFit()
                .frame(width: ItemWidth * 0.3, height: ItemWidth * 0.3)
                .foregroundColor(.gray)
            if Folder.IsFavorite && !ViewModel.IsSelecting {
                Image(systemName: "heart.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: ItemWidth * 0.08, height: ItemWidth * 0.08)
                    .foregroundColor(.red)
                    .offset(x: CircleOffset.x, y: CircleOffset.y)
            }
            if ViewModel.IsSelecting {
                Circle()
                    .stroke(.gray, lineWidth: 2)
                    .background(Circle().fill(Color.white))
                    .overlay(
                        ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ?
                        Circle().stroke(.gray, lineWidth: 2).frame(width: 10, height: 10) : nil
                    )
                    .frame(width: 20, height: 20)
                    .offset(x: CircleOffset.x, y: CircleOffset.y)
            }
        }
    }
    
    private var FolderContextMenu: some View {
        VStack {
            Button {
                ViewModel.PinFolder(For: Folder)
            } label: {
                Label(
                    ViewModel.Folders.contains { $0.Name == Folder.Name && $0.IsPinned } ? StringConstants.ContextMenu.Unpin.Text : StringConstants.ContextMenu.Pin.Text,
                    systemImage: Folder.IsPinned ? StringConstants.ContextMenu.Unpin.SystemImage : StringConstants.ContextMenu.Pin.SystemImage
                )
            }
            Button {
                ViewModel.ToggleFavorite(For: Folder)
            } label: {
                Label(
                    Folder.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                    systemImage: Folder.IsFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
                )
            }
            Divider()
            Button {
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

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(ViewModel: FolderViewModel(), Folder: FolderModel(Name: "LVS"), ItemWidth: 100)
    }
}
