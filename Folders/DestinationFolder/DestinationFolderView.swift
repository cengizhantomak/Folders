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
        }
    }
}

//#Preview {
//    DestinationFolderView()
//}
