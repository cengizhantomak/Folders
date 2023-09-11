//
//  FolderContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct FolderContentView: View {
    @StateObject var ViewModel: FolderContentViewModel
    
    var body: some View {
        Text(ViewModel.Folder.Name)
            .font(.title)
            .navigationBarTitle(ViewModel.Folder.Name, displayMode: .inline)
    }
}

struct FolderContentView_Previews: PreviewProvider {
    static var previews: some View {
        FolderContentView(ViewModel: FolderContentViewModel(Folder: FolderModel(Name: "LVS")))
    }
}
