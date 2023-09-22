//
//  FolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI
import LVRealmKit

struct FolderView: View {
    @StateObject var ViewModel = FolderViewModel()
    
    var body: some View {
        NavigationStack {
            VStack {
                if ViewModel.Sessions.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: StringConstants.SystemImage.NoVideo)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        Text(StringConstants.NoVideo)
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                    .ignoresSafeArea(.all)
                } else {
                    GeometryReader { Geometry in
                        let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 12, Amount: 2)
                        ScrollView {
                            VStack(alignment: .leading, spacing: 44) {
                                CreateSection(WithTitle: StringConstants.SectionTitle.Todays, Folders: ViewModel.TodaySection, ItemWidth: ItemWidth)
//                                CreateSection(WithTitle: StringConstants.SectionTitle.Pinned, Folders: ViewModel.PinnedFolders, ItemWidth: ItemWidth)
                                CreateSection(WithTitle: StringConstants.SectionTitle.Session, Folders: ViewModel.SessionSection, ItemWidth: ItemWidth)
                            }
                            .padding(10)
                        }
                    }
                }
            }
            .navigationTitle(StringConstants.Videos)
            .toolbar {
                if !ViewModel.IsSelecting {
                    ToolbarItemGroup(placement: .navigationBarLeading) {
                        Button {
                            ViewModel.AddFolder(SessionModel())
                        } label: {
                            Image(systemName: StringConstants.SystemImage.Plus)
                                .foregroundColor(.primary)
                                .padding(8)
                                .background(Color.gray.opacity(0.25))
                                .clipShape(Circle())
                        }
//                        Button {
//                            ViewModel.AddFolderWithAssetVideo()
//                        } label: {
//                            Text("Ekle")
//                                .foregroundColor(.primary)
//                                .padding(8)
//                                .background(Color.gray.opacity(0.25))
//                                .clipShape(Capsule())
//                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack(spacing: 0) {
//                            Button {
//                                ViewModel.FavoritesButtonAction()
//                            } label: {
//                                Image(systemName: ViewModel.OnlyShowFavorites ? StringConstants.SystemImage.HeartFill : StringConstants.SystemImage.Heart)
//                                    .foregroundColor(.primary)
//                                    .padding(8)
//                                    .background(Color.gray.opacity(0.25))
//                                    .clipShape(Circle())
//                            }
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
                        Text(ViewModel.SelectionCountText(For: ViewModel.SelectedSessions.count))
                            .foregroundColor(ViewModel.SelectedSessions.isEmpty ? .gray : .primary)
                        Spacer()
                        Button {
                            ViewModel.ShowDeleteAlert = true
                        } label: {
                            Image(systemName: StringConstants.SystemImage.Trash)
                                .foregroundColor(ViewModel.SelectedSessions.isEmpty ? .gray : .primary)
                        }
                        .disabled(ViewModel.SelectedSessions.isEmpty)
                    }
                }
            }
//            .alert(StringConstants.Alert.Title.CreateFolder, isPresented: $ViewModel.ShowCreatedAlert) {
//                TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.FolderName)
//                Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
//                    if !ViewModel.FolderName.isEmpty {
//                        ViewModel.AddFolder()
//                    } else {
//                        ViewModel.IsErrorTTProgressHUDVisible = true
//                    }
//                }
//                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
//                    print("Cancel Tapped")
//                }
//            }
            .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowDeleteAlert) {
                Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                    ViewModel.DeleteFolders(ViewModel.SelectedSessions)
                    ViewModel.IsSelecting = false
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Cancel Tapped")
                }
            } message: {
                Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
            }
//            .onAppear(perform: {
//                ViewModel.LoadFolders()
//            })
        }
//        .overlay {
//            CustomTTProgressHUD(IsSuccessVisible: $ViewModel.IsSuccessTTProgressHUDVisible, IsErrorVisible: $ViewModel.IsErrorTTProgressHUDVisible)
//        }
    }
    
    private func CreateSection(WithTitle Title: String, Folders: [SessionModel], ItemWidth: CGFloat) -> some View {
        Group {
            if !Folders.isEmpty {
                VStack(alignment: .leading) {
                    Divider()
                    Section(header: Text(Title).font(.headline)) {
                        FolderGridView(ViewModel: ViewModel, Folders: Folders, ItemWidth: ItemWidth)
                    }
                }
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}
