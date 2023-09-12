//
//  FolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct FolderView: View {
    @StateObject var ViewModel = FolderViewModel()
    
    var body: some View {
        NavigationStack {
            GeometryReader { Geometry in
                let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 30, Amount: 2)
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CreateSection(WithTitle: StringConstants.SectionTitle.Todays, Folders: ViewModel.TodayFolders, ItemWidth: ItemWidth)
                        CreateSection(WithTitle: StringConstants.SectionTitle.Pinned, Folders: ViewModel.PinnedFolders, ItemWidth: ItemWidth)
                        CreateSection(WithTitle: StringConstants.SectionTitle.Session, Folders: ViewModel.SessionFolders, ItemWidth: ItemWidth)
                    }
                    .padding(10)
                }
                .navigationTitle(StringConstants.Videos)
                .toolbar {
                    if !ViewModel.IsSelecting {
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
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            HStack(spacing: 0) {
                                Button {
                                    ViewModel.FavoritesButtonAction()
                                } label: {
                                    Image(systemName: ViewModel.OnlyShowFavorites ? StringConstants.SystemImage.HeartFill : StringConstants.SystemImage.Heart)
                                        .foregroundColor(.primary)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.25))
                                        .clipShape(Circle())
                                }
                                Button {
                                    ViewModel.SelectCancelButtonAction()
                                } label: {
                                    Text(StringConstants.Select)
                                        .foregroundColor(.primary)
                                        .padding(8)
                                        .background(Color.gray.opacity(0.25))
                                        .clipShape(Capsule())
                                }
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button {
                                ViewModel.SelectCancelButtonAction()
                            } label: {
                                Text(StringConstants.Cancel)
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Capsule())
                            }
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Text(ViewModel.SelectionCountText(For: ViewModel.SelectedFolders.count))
                                .foregroundColor(ViewModel.SelectedFolders.isEmpty ? .gray : .primary)
                            Spacer()
                            Button {
                                if !ViewModel.SelectedFolders.isEmpty {
                                    ViewModel.ShowBottomBarDeleteAlert = true
                                }
                            } label: {
                                Image(systemName: StringConstants.SystemImage.Trash)
                                    .foregroundColor(ViewModel.SelectedFolders.isEmpty ? .gray : .primary)
                            }
                        }
                    }
                }
                .alert(StringConstants.Alert.Title.CreateFolder, isPresented: $ViewModel.ShowCreatedAlert) {
                    TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.InputName)
                    Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                        ViewModel.AddFolder()
                    }
                    Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                        print("Cancel Tapped")
                    }
                }
                .alert(isPresented: $ViewModel.ShowBottomBarDeleteAlert) {
                    Alert(title: Text(StringConstants.Alert.Title.Deleting),
                          message: Text(StringConstants.Alert.Message.DeleteConfirmationMessage),
                          primaryButton: .destructive(Text(StringConstants.Alert.ButtonText.Delete)) {
                        for Folder in ViewModel.SelectedFolders {
                            ViewModel.RemoveFolder(For: Folder)
                        }
                        ViewModel.SelectedFolders.removeAll()
                        ViewModel.IsSelecting.toggle()
                    },
                          secondaryButton: .cancel())
                }
            }
        }
    }
    
    private func CreateSection(WithTitle Title: String, Folders: [FolderModel], ItemWidth: CGFloat) -> some View {
        Group {
            if !Folders.isEmpty {
                VStack(alignment: .leading) {
                    FolderSectionView(Title: Title)
                    FolderGridView(ViewModel: ViewModel, Folders: Folders, ItemWidth: ItemWidth)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        FolderView()
    }
}
