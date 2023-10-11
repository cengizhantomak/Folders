//
//  DestinationFolderDetailView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 2.10.2023.
//

import SwiftUI
import LVRealmKit
import CustomAlertPackage

struct DestinationFolderDetailView: View {
    @StateObject var ViewModel: DestinationFolderDetailViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if ViewModel.Session.practiceCount == 0 {
                    NoVideoView()
                } else {
                    List(ViewModel.Practices, id: \.id) { Practice in
                        NavigationLink(destination: VideoPlayerView(url: Practice.VideoPath)) {
                            PracticeRowView(Practice: Practice)
                        }
                        .foregroundColor(.primary)
                    }
                }
            }
            .navigationBarTitle(ViewModel.Session.name, displayMode: .inline)
            .toolbar {
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
                }
            }
        }
        .CustomAlert(
            IsPresented: $ViewModel.ShowMoveAlert,
            Title: Title(Text: StringConstants.Alert.Title.MoveVideo,
                         SystemImage: StringConstants.SystemImage.FolderBadgePlus),
            Message: StringConstants.Alert.Message.MoveConfirmationMessage,
            ButtonLeft: AlertButton(Text: StringConstants.Alert.ButtonText.Cancel,
                                    Action: {
                                        print("Cancel Tapped")
                                    }),
            ButtonRight: AlertButton(Text: StringConstants.Alert.ButtonText.Move,
                                     Action: {
                                         ViewModel.MovePractice()
                                     })
        )
    }
}

struct PracticeRowView: View {
    var Practice: PracticeModel
    
    var body: some View {
        HStack {
            if let ThumbPath = Practice.ThumbPath {
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
            VStack(alignment: .leading) {
                Text(Practice.Name)
                Text(Date.CurrentTime(From: Practice.UpdatedAt))
                    .font(.subheadline)
                    .foregroundStyle(.gray)
            }
        }
    }
}


//#Preview {
//    DestinationFolderDetailView()
//}
