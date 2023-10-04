//
//  DestinationFolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 29.09.2023.
//

import SwiftUI
import TTProgressHUD
import LVRealmKit

struct DestinationFolderView: View {
    @StateObject var ViewModel: DestinationFolderViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if ViewModel.Sessions.isEmpty {
                    NoVideoView()
                } else {
                    List(ViewModel.FilteredSessions, id: \.id) { Folder in
                        NavigationLink(destination: DestinationFolderDetailView(ViewModel: DestinationFolderDetailViewModel(Folder: Folder, DestinationFolderViewModel: ViewModel))) {
                            FolderRowView(Folder: Folder)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .searchable(text: $ViewModel.SearchText)
            .navigationBarTitle(StringConstants.Move, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        ViewModel.AddButtonAction()
                    } label: {
                        Image(systemName: StringConstants.SystemImage.Plus)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        ViewModel.PracticeViewModel?.ShowBottomBarMoveAlert = false
                    } label: {
                        Text(StringConstants.Cancel)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Capsule())
                    }
                }
            }
            .alert(StringConstants.Alert.Title.CreateFolder, isPresented: $ViewModel.ShowCreatedAlert) {
                TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.FolderName)
                Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                    if !ViewModel.FolderName.isEmpty {
                        ViewModel.AddFolder()
                    } else {
                        ViewModel.ErrorTTProgressHUD()
                    }
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Creat Alert Cancel Tapped")
                }
            }
        }
        .overlay {
            CustomTTProgressHUD(IsVisible: $ViewModel.IsSuccessTTProgressHUDVisible, HudType: .success)
            CustomTTProgressHUD(IsVisible: $ViewModel.IsErrorTTProgressHUDVisible, HudType: .error)
        }
    }
}

struct FolderRowView: View {
    var Folder: SessionModel
    
    var body: some View {
        HStack {
            if let ThumbPath = Folder.thumbnail {
                Image(uiImage: UIImage(contentsOfFile: URL.documentsDirectory.appending(path: ThumbPath).path) ?? UIImage())
                    .resizable()
                    .scaledToFill()
                    .frame(width: 50, height: 50)
                    .cornerRadius(5)
            } else {
                ZStack {
                    Rectangle()
                        .fill(Color.gray.opacity(0.15))
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                    Image(systemName: StringConstants.SystemImage.RectangleStackBadgePlay)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 30, height: 30)
                        .foregroundColor(.gray)
                }
            }
            VStack(alignment: .leading) {
                Text(Folder.name)
                Text(String(Folder.practiceCount))
                    .font(.subheadline)
                    .foregroundColor(.gray)
            }
        }
    }
}

//#Preview {
//    DestinationFolderView()
//}
