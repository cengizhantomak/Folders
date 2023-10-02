//
//  DestinationFolderView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 29.09.2023.
//

import SwiftUI

struct DestinationFolderView: View {
    @StateObject var ViewModel: DestinationFolderViewModel
    
    var body: some View {
        NavigationStack {
            List(ViewModel.Sessions, id: \.id) { Folder in
                Text(Folder.name)
                    .onTapGesture {
                        ViewModel.SelectedFolder = Folder
                        ViewModel.ShowMoveAlert = true
                    }
                    .alert(StringConstants.Alert.Title.MoveVideo, isPresented: $ViewModel.ShowMoveAlert) {
                        Button(StringConstants.Alert.ButtonText.Move, role: .destructive) {
                            ViewModel.MovePractice()
                        }
                        Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                            print("Cancel Tapped")
                        }
                    } message: {
                        Text(StringConstants.Alert.Message.MoveConfirmationMessage)
                    }
            }
            .navigationBarTitle("Move Practice")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        print("Cancel Tapped")
                    } label: {
                        Text("Cancel")
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Capsule())
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button {
                        ViewModel.AddButtonAction()
                        print("Add Folder")
                    } label: {
                        Image(systemName: StringConstants.SystemImage.Plus)
                            .foregroundColor(.primary)
                            .padding(8)
                            .background(Color.gray.opacity(0.25))
                            .clipShape(Circle())
                    }
                }
            }
            .alert(StringConstants.Alert.Title.CreateFolder, isPresented: $ViewModel.ShowCreatedAlert) {
                TextField(StringConstants.Alert.Title.FolderName, text: $ViewModel.FolderName)
                Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                    if !ViewModel.FolderName.isEmpty {
                        ViewModel.AddFolder()
                    } else {
//                        ViewModel.ErrorTTProgressHUD()
                    }
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Cancel Tapped")
                }
            }
        }
    }
}

//#Preview {
//    DestinationFolderView()
//}