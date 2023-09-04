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
            Rectangle()
                .fill(Color.gray)
                .frame(width: ItemWidth, height: ItemWidth * 1.5)
                .cornerRadius(10)
            
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
