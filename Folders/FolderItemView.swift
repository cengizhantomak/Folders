//
//  FolderItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct FolderItemView: View {
    var Folder: FolderModel
    let ItemWidth: CGFloat
    
    var body: some View {
        VStack(alignment: .leading) {
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
                Button(action: {
                    // TODO: - Pin
                }, label: {
                    Label("Pin", systemImage: "pin")
                })
                
                Button(action: {
                    // TODO: - Add Favorite functionality
                }, label: {
                    Label("Add Favorite", systemImage: "heart")
                })
                
                Divider()
                
                Button(action: {
                    //TODO: - Rename functionality
                }, label: {
                    Label("Rename", systemImage: "pencil")
                })
                
                if #available(iOS 15.0, *) {
                    Button(role: .destructive, action: {
                        // TODO: - Delete
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                } else {
                    Button(action: {
                        // TODO: - Delete for older iOS
                    }, label: {
                        Label("Delete", systemImage: "trash")
                    })
                }
            }
            Text(Folder.Name)
                .font(.system(size: 15))
        }
    }
}

struct FolderItemView_Previews: PreviewProvider {
    static var previews: some View {
        FolderItemView(Folder: FolderModel(Name: "unknown"), ItemWidth: 100)
    }
}
