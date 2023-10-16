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
                    CustomSearchBar(Placeholder: "Search", Text: $ViewModel.SearchText)
                        .padding(.horizontal)
                    MultiSegmentView
                    GeometryReader { Geometry in
                        let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 12, Amount: CGFloat(ViewModel.Columns.count))
                        ScrollView {
                            LazyVGrid(columns: ViewModel.Columns, spacing: 10) {
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
                            .padding(10)
                        }
                        .scrollDismissesKeyboard(.immediately)
                    }
//                    .searchable(text: $ViewModel.SearchText)
                }
            }
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
                            .foregroundColor(ViewModel.SelectedFolder == nil ? .gray : .primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Capsule())
                    }
                    .disabled(ViewModel.SelectedFolder == nil)
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
    
    // MARK: - MultiSegmentView
    private var MultiSegmentView: some View {
        HStack(spacing: 1) {
            Button(action: {
                ViewModel.ShowFavorited.toggle()
            }) {
                Text("Favorited")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(ViewModel.ShowFavorited ? Color.gray.opacity(0.5) : Color.gray.opacity(0.15))
                    .foregroundColor(ViewModel.ShowFavorited ? Color.primary : Color.gray)
            }

            Button(action: {
                ViewModel.ShowPinned.toggle()
            }) {
                Text("Pinned")
                    .frame(minWidth: 0, maxWidth: .infinity)
                    .padding(.vertical, 5)
                    .background(ViewModel.ShowPinned ? Color.gray.opacity(0.5) : Color.gray.opacity(0.15))
                    .foregroundColor(ViewModel.ShowPinned ? Color.primary : Color.gray)
            }
        }
        .cornerRadius(8)
        .padding(.horizontal)
    }
}

//#Preview {
//    DestinationFolderView()
//}
