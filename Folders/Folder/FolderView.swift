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
            FolderViewContent
                .navigationTitle(StringConstants.Videos)
                .toolbar {
                    Toolbars
                }
                .alert(StringConstants.Alert.Title.CreateFolder, isPresented: $ViewModel.ShowCreatedAlert) {
                    CreatedAlert
                }
                .alert(StringConstants.Alert.Title.RenameFolder, isPresented: $ViewModel.ShowRenameAlert) {
                    RenameVideoAlert
                }
                .alert(isPresented: $ViewModel.ShowDeleteAlert) {
                    DeleteAlert
                }
                .onAppear {
                    ViewModel.LoadFolders()
                }
        }
        .overlay {
            ProgressHUD
        }
    }
}


extension FolderView {
    // MARK: - Content
    private var FolderViewContent: some View {
        Group {
            if ViewModel.Sessions.isEmpty {
                NoVideoView()
            } else {
                FolderContent
            }
        }
    }
    
    private var FolderContent: some View {
        GeometryReader { Geometry in
            let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 12, Amount: 2)
            ScrollView {
                VStack(alignment: .leading, spacing: 44) {
                    CreateSection(WithTitle: StringConstants.SectionTitle.Todays, Folders: ViewModel.TodaySection, ItemWidth: ItemWidth)
                    CreateSection(WithTitle: StringConstants.SectionTitle.Pinned, Folders: ViewModel.PinnedSection, ItemWidth: ItemWidth)
                    CreateSection(WithTitle: StringConstants.SectionTitle.Session, Folders: ViewModel.SessionSection, ItemWidth: ItemWidth)
                }
                .padding(10)
            }
        }
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
    
    // MARK: - Toolbars
    private var Toolbars: some ToolbarContent {
        Group {
            if !ViewModel.IsSelecting {
                DefaultTopBarLeading
                DefaultTopBarTrailing
            } else {
                SelectionTopBarTrailing
                SelectionBottomBar
            }
        }
    }
    
    private var DefaultTopBarLeading: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarLeading) {
            Button {
                ViewModel.AddButtonAction()
            } label: {
                Image(systemName: StringConstants.SystemImage.Plus)
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color.gray.opacity(0.25))
                    .clipShape(Circle())
            }
            Button {
                ViewModel.AddPractice()
            } label: {
                Text("Ekle")
                    .foregroundColor(.primary)
                    .padding(8)
                    .background(Color.gray.opacity(0.25))
                    .clipShape(Capsule())
            }
        }
    }
    
    private var DefaultTopBarTrailing: some ToolbarContent {
        ToolbarItemGroup(placement: .topBarTrailing) {
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
    }
    
    private var SelectionTopBarTrailing: some ToolbarContent {
        ToolbarItem(placement: .topBarTrailing) {
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
    }
    
    private var SelectionBottomBar: some ToolbarContent {
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
    
    // MARK: - Alerts
    private var CreatedAlert: some View {
        Group {
            TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.FolderName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.FolderName.isEmpty {
                    ViewModel.AddFolder()
                } else {
                    ViewModel.ErrorTTProgressHUD()
                }
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
    
    private var RenameVideoAlert: some View {
        Group {
            TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenameFolder(NewName: ViewModel.NewName)
                } else {
                    ViewModel.ErrorTTProgressHUD()
                }
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
    
    private var DeleteAlert: Alert {
        Alert(
            title: Text(StringConstants.Alert.Title.Deleting),
            message: Text(StringConstants.Alert.Message.DeleteConfirmationMessage),
            primaryButton: .destructive(Text(StringConstants.Alert.ButtonText.Delete)) {
                ViewModel.DeleteFolders(ViewModel.SelectedSessions)
                ViewModel.IsSelecting = false
            },
            secondaryButton: .cancel {
                print("Cancel Tapped")
            }
        )
    }
    
    // MARK: - ProgressHUD
    private var ProgressHUD: some View {
        Group {
            if ViewModel.IsSuccessTTProgressHUDVisible {
                CustomTTProgressHUD(IsVisible: $ViewModel.IsSuccessTTProgressHUDVisible, HudType: .success)
            } else if ViewModel.IsErrorTTProgressHUDVisible {
                CustomTTProgressHUD(IsVisible: $ViewModel.IsErrorTTProgressHUDVisible, HudType: .error)
            }
        }
    }
}

//struct FolderView_Previews: PreviewProvider {
//    static var previews: some View {
//        FolderView()
//    }
//}
