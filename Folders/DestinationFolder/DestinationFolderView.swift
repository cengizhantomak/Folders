//
//  DestinationFolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 29.09.2023.
//

import SwiftUI
import TTProgressHUD

struct DestinationFolderView: View {
    @StateObject var ViewModel: DestinationFolderViewModel
    
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
                    List(ViewModel.Sessions, id: \.id) { Folder in
                        NavigationLink(destination: DestinationFolderDetailView(ViewModel: DestinationFolderDetailViewModel(Folder: Folder, DestinationFolderViewModel: ViewModel))) {
                            Text(Folder.name)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarTitle("Move Practice")
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

//#Preview {
//    DestinationFolderView()
//}
