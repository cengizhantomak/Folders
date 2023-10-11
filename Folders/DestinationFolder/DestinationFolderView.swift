//
//  DestinationFolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 29.09.2023.
//

import SwiftUI
import TTProgressHUD
import LVRealmKit
import CustomAlertPackage

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
        }
        .CustomAlert(
            IsPresented: $ViewModel.ShowCreatedAlert,
            Title: Title(Text: StringConstants.Alert.Title.CreateFolder,
                         SystemImage: StringConstants.Alert.SystemImage.FolderFillBadgePlus),
            TextField: TextFieldText(Placeholder: StringConstants.Alert.Title.FolderName,
                                     Text: $ViewModel.FolderName),
            LabelLeft: LabelButton(Text: StringConstants.ContextMenu.AddFavorite.Text,
                                   SystemImage: ViewModel.FolderFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage,
                                   Binding: $ViewModel.FolderFavorite,
                                   Action: {
                                       ViewModel.FolderFavorite.toggle()
                                   }),
            LabelRight: LabelButton(Text: StringConstants.ContextMenu.Pin.Text, SystemImage: ViewModel.FolderPinned ? StringConstants.ContextMenu.Pin.SystemImage : StringConstants.ContextMenu.Unpin.SystemImage,
                                    Binding: $ViewModel.FolderPinned,
                                    Action: {
                                        ViewModel.FolderPinned.toggle()
                                    }),
            ButtonLeft: AlertButton(Text: StringConstants.Alert.ButtonText.Cancel,
                                    Action: {
                                        print("Cancel Tapped")
                                    }),
            ButtonRight: AlertButton(Text: StringConstants.Alert.ButtonText.Create,
                                     Action: {
                                         if !ViewModel.FolderName.isEmpty {
                                             ViewModel.AddFolder()
                                         } else {
                                             ViewModel.ErrorTTProgressHUD()
                                         }
                                     })
        )
        .overlay {
            if ViewModel.IsSuccessTTProgressHUDVisible {
                CustomTTProgressHUD(IsVisible: $ViewModel.IsSuccessTTProgressHUDVisible, HudType: .success)
            } else if ViewModel.IsErrorTTProgressHUDVisible {
                CustomTTProgressHUD(IsVisible: $ViewModel.IsErrorTTProgressHUDVisible, HudType: .error)
            }
        }
    }
}

struct FolderRowView: View {
    var Folder: SessionModel
    
    var body: some View {
        HStack {
            if let ThumbPath = Folder.thumbnail {
                AsyncImage(url: URL.documentsDirectory.appending(path: ThumbPath)) { Image in
                    Image
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .cornerRadius(5)
                } placeholder: {
                    ProgressView()
                }
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
