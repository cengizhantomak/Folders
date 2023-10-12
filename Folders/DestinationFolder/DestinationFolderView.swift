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
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        NavigationStack {
            VStack {
                if ViewModel.Sessions.isEmpty {
                    NoVideoView()
                } else {
                    GeometryReader { Geometry in
                        let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 12, Amount: CGFloat(ViewModel.Columns.count))
                        ScrollView {
                            LazyVGrid(columns: ViewModel.Columns, spacing: 12) {
                                ForEach(ViewModel.FilteredSessions, id: \.id) { Folder in
                                    DestinationFolderItemView(ViewModel: ViewModel, Folder: Folder, ItemWidth: ItemWidth)
                                        .onTapGesture {
                                            if ViewModel.SelectedFolder?.id == Folder.id {
                                                ViewModel.SelectedFolder = nil
                                            } else {
                                                ViewModel.SelectedFolder = Folder
                                            }
                                        }
                                }
                            }
                        }
                    }
                }
            }
            .searchable(text: $ViewModel.SearchText)
            .navigationBarTitle(StringConstants.Move, displayMode: .inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
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
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        ViewModel.ShowMoveAlert = true
                    } label: {
                        Text(StringConstants.Move)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Capsule())
                    }
//                    Button {
//                        ViewModel.PracticeViewModel?.ShowBottomBarMoveAlert = false
//                    } label: {
//                        Text(StringConstants.Cancel)
//                            .foregroundColor(.primary)
//                            .padding(8)
//                            .background(Color.gray.opacity(0.25))
//                            .clipShape(Capsule())
//                    }
                }
            }
        }
        .CustomAlert(
            IsPresented: $ViewModel.ShowCreatedAlert,
            Title: Title(
                Text: StringConstants.Alert.Title.CreateFolder,
                SystemImage: StringConstants.Alert.SystemImage.FolderFillBadgePlus
            ),
            TextField: TextFieldText(
                Placeholder: StringConstants.Alert.Title.FolderName,
                Text: $ViewModel.FolderName
            ),
            LabelLeft: LabelButton(
                Text: StringConstants.ContextMenu.AddFavorite.Text,
                SystemImage: ViewModel.FolderFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage,
                Binding: $ViewModel.FolderFavorite,
                Action: {
                    ViewModel.FolderFavorite.toggle()
                }
            ),
            LabelRight: LabelButton(
                Text: StringConstants.ContextMenu.Pin.Text,
                SystemImage: ViewModel.FolderPinned ? StringConstants.ContextMenu.Pin.SystemImage : StringConstants.ContextMenu.Unpin.SystemImage,
                Binding: $ViewModel.FolderPinned,
                Action: {
                    ViewModel.FolderPinned.toggle()
                }
            ),
            ButtonLeft: AlertButton(
                Text: StringConstants.Alert.ButtonText.Cancel,
                Action: {
                    print("Cancel Tapped")
                }
            ),
            ButtonRight: AlertButton(
                Text: StringConstants.Alert.ButtonText.Create,
                Action: {
                    if !ViewModel.FolderName.isEmpty {
                        ViewModel.AddFolder()
                    } else {
                        ViewModel.ErrorTTProgressHUD()
                    }
                }
            )
        )
        .CustomAlert(
            IsPresented: $ViewModel.ShowMoveAlert,
            Title: Title(
                Text: StringConstants.Alert.Title.MoveVideo,
                SystemImage: StringConstants.SystemImage.FolderBadgePlus
            ),
            Message: StringConstants.Alert.Message.MoveConfirmationMessage,
            ButtonLeft: AlertButton(
                Text: StringConstants.Alert.ButtonText.Cancel,
                Action: {
                    print("Cancel Tapped")
                }
            ),
            ButtonRight: AlertButton(
                Text: StringConstants.Alert.ButtonText.Move,
                Action: {
                    ViewModel.MovePractice()
                }
            )
        )
        .onAppear {
            let ItemCount = ViewModel.NumberOfItemsPerRow(For: horizontalSizeClass)
            ViewModel.Columns = Array(repeating: GridItem(.flexible()), count: ItemCount)
        }
        .overlay {
            if ViewModel.IsSuccessTTProgressHUDVisible {
                CustomTTProgressHUD(
                    IsVisible: $ViewModel.IsSuccessTTProgressHUDVisible,
                    HudType: .success
                )
            } else if ViewModel.IsErrorTTProgressHUDVisible {
                CustomTTProgressHUD(
                    IsVisible: $ViewModel.IsErrorTTProgressHUDVisible,
                    HudType: .error
                )
            }
        }
    }
}

//#Preview {
//    DestinationFolderView()
//}
