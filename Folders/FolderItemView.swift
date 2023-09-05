//
//  FolderItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct FolderItemView: View {
    @Binding var Folder: FolderModel
    let ItemWidth: CGFloat
    @StateObject var ViewModel: FolderViewModel
    @State private var IsRenameShowAlert = false
    @State private var IsDeleteShowAlert = false
    @State private var NewName = ""
    
    var body: some View {
        Group {
            VStack(alignment: .leading) {
                FolderIcon
                Text(Folder.Name)
                    .font(.system(size: 15))
            }
        }
        .onAppear {
            NewName = Folder.Name
        }
        .alert("Rename Folder", isPresented: $IsRenameShowAlert) {
            TextField("Folder Name", text: $NewName)
            Button("Save", role: .destructive) {
                ViewModel.RenameFolder(WithId: Folder.id, NewName: NewName)
            }
            Button("Cancel", role: .cancel) {
                NewName = Folder.Name
                print("Cancel Tapped")
            }
        }
        .alert(isPresented: $IsDeleteShowAlert) {
            Alert(
                title: Text("Deleting!"),
                message: Text("Are you sure you want to delete the selected folders?"),
                primaryButton: .destructive(Text("Delete"), action: {
                    ViewModel.RemoveFolder(WithId: Folder.id)
                }),
                secondaryButton: .cancel()
            )
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
                .foregroundColor(Color.gray)
        }
        .contextMenu {
            FolderContextMenu
        }
    }
    
    private var FolderContextMenu: some View {
        VStack {
            Button(action: {
                // TODO: - Pin
            }, label: {
                Label("Pin", systemImage: "pin")
            })
            
            Button(action: {
                // TODO: - Add Favorite
            }, label: {
                Label("Add Favorite", systemImage: "heart")
            })
            
            Divider()
            
            Button(action: {
                IsRenameShowAlert = true
            }, label: {
                Label("Rename", systemImage: "pencil")
            })
            
            Button(role: .destructive, action: {
                IsDeleteShowAlert = true
            }, label: {
                Label("Delete", systemImage: "trash")
            })
        }
    }
}

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(Folder: .constant(FolderModel(Name: "unknown")), ItemWidth: 100, ViewModel: FolderViewModel())
        
    }
}
