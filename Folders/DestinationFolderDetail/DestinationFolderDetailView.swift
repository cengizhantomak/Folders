//
//  DestinationFolderDetailView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 2.10.2023.
//

import SwiftUI
import LVRealmKit

struct DestinationFolderDetailView: View {
    @StateObject var ViewModel: DestinationFolderDetailViewModel
    
    var body: some View {
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
        .alert(StringConstants.Alert.Title.MoveVideo, isPresented: $ViewModel.ShowMoveAlert) {
            Button(StringConstants.Alert.ButtonText.Move, role: .destructive) {
                ViewModel.MovePractice()
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Move Alert Cancel Tapped")
            }
        } message: {
            Text(StringConstants.Alert.Message.MoveConfirmationMessage)
        }
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
