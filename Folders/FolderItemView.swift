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
        .alert("Rename Folder", isPresented: $ViewModel.ShowRenameAlert) {
            TextField("Folder Name", text: $ViewModel.NewName)
            Button("Save", role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameFolder(For: Folder, NewName: ViewModel.NewName)
                }
            }
            Button("Cancel", role: .cancel) {
                ViewModel.NewName = Folder.Name
                print("Cancel Tapped")
            }
        }
        .alert(isPresented: $ViewModel.ShowDeleteAlert) {
            Alert(title: Text("Deleting!"),
                  message: Text("Are you sure you want to delete the selected folders?"),
                  primaryButton: .destructive(Text("Delete")) {
                ViewModel.RemoveFolder(For: Folder)
            },
                  secondaryButton: .cancel())
        }
    }
    
    private var FolderIcon: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: ItemWidth, height: ItemWidth * 1.5)
                .cornerRadius(10)
            Image(systemName: "rectangle.stack.badge.play")
                .resizable()
                .scaledToFit()
                .frame(width: ItemWidth * 0.3, height: ItemWidth * 0.3)
                .foregroundColor(.gray)
            
            if ViewModel.IsSelecting {
                Circle()
                    .stroke(.gray, lineWidth: 2)
                    .background(ViewModel.SelectedFolders.contains(where: { $0.id == Folder.id }) ? Circle().fill(.gray).frame(width: 12, height: 12) : nil)
                    .frame(width: 20, height: 20)
                    .offset(x: (ItemWidth/2) - 20, y: -(ItemWidth * 1.5 / 2) + 20)
            }
        }
    }
    
    private var FolderContextMenu: some View {
        VStack {
            Button {
                ViewModel.PinFolder(For: Folder)
            } label: {
                Label(ViewModel.PinActionLabel(For: Folder.Name), systemImage: Folder.IsPinned ? "pin.slash" : "pin")
            }
            Button {
                // TODO: - Add Favorite
            } label: {
                Label("Add Favorite", systemImage: "heart")
            }
            Divider()
            Button {
                ViewModel.ShowRenameAlert = true
            } label: {
                Label("Rename", systemImage: "pencil")
            }
            
            Button(role: .destructive) {
                ViewModel.ShowDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(ViewModel: FolderViewModel(), Folder: FolderModel(Name: "LVS"), ItemWidth: 100)
    }
}
