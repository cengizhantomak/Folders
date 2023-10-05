//
//  PracticeView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct PracticeView: View {
    @StateObject var ViewModel: PracticeViewModel
    
    var body: some View {
        PracticeViewContent
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Toolbars
            }
            .alert(StringConstants.Alert.Title.RenameVideo, isPresented: $ViewModel.ShowRenameAlert) {
                RenamePracticeAlert
            }
            .alert(isPresented: $ViewModel.ShowDeleteAlert) {
                DeleteAlert
            }
            .sheet(isPresented: $ViewModel.ShowBottomBarMoveAlert) {
                DestinationFolderView(ViewModel: DestinationFolderViewModel(PracticeViewModel: ViewModel))
            }
            .overlay {
                SessionTitle
                ProgressHUD
            }
    }
}


extension PracticeView {
    // MARK: - Content
    private var PracticeViewContent: some View {
        if ViewModel.Session.practiceCount == 0 {
            AnyView(NoVideoContent)
        } else {
            AnyView(PracticeContent)
        }
    }
    
    private var NoVideoContent: some View {
        ZStack {
            NoVideoView()
        }
    }
    
    private var PracticeContent: some View {
        GeometryReader { Geometry in
            let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 1, Amount: 3)
            ScrollView {
                PracticeGridView(ViewModel: ViewModel, ItemWidth: ItemWidth)
                    .padding(5)
            }
        }
    }
    
    // MARK: - Toolbars
    private var Toolbars: some ToolbarContent {
        Group {
            if !ViewModel.IsSelecting {
                DefaultTopBar
            } else {
                SelectionTopBar
                SelectionBottomBar
            }
        }
    }
    
    private var DefaultTopBar: some ToolbarContent {
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
    
    private var SelectionTopBar: some ToolbarContent {
        Group {
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
    }
    
    private var SelectionBottomBar: some ToolbarContent {
        ToolbarItemGroup(placement: .bottomBar) {
            Button {
                ViewModel.ShowBottomBarMoveAlert = true
            } label: {
                Image(systemName: StringConstants.SystemImage.FolderBadgePlus)
                    .foregroundColor(ViewModel.SelectedPractices.isEmpty ? .gray : .primary)
            }
            .disabled(ViewModel.SelectedPractices.isEmpty)
            
            Spacer()
            
            Text(ViewModel.SelectionCount(For: ViewModel.SelectedPractices.count))
                .foregroundColor(ViewModel.SelectedPractices.isEmpty ? .gray : .primary)
            
            Spacer()
            
            Button {
                ViewModel.ShowDeleteAlert = true
            } label: {
                Image(systemName: StringConstants.SystemImage.Trash)
                    .foregroundColor(ViewModel.SelectedPractices.isEmpty ? .gray : .primary)
            }
            .disabled(ViewModel.SelectedPractices.isEmpty)
        }
    }
    
    // MARK: - Alerts
    private var RenamePracticeAlert: some View {
        Group {
            TextField(StringConstants.Alert.Title.VideoName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenamePractice()
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
                ViewModel.DeletePractices(ViewModel.SelectedPractices)
                ViewModel.IsSelecting = false
            },
            secondaryButton: .cancel {
                print("Cancel Tapped")
            }
        )
    }
    
    // MARK: - Title
    private var SessionTitle: some View {
        VStack {
            HStack {
                Text(ViewModel.Session.name)
                    .lineLimit(1)
                    .minimumScaleFactor(0.5)
                    .font(.title2)
                    .background(Color.clear)
                    .padding(10)
                    .frame(alignment: .leading)
                Spacer(minLength: 100)
            }
            Spacer()
        }
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

//struct PracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeView(ViewModel: PracticeViewModel(Folder: FolderModel(Name: "LVS")))
//    }
//}
