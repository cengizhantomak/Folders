//
//  DestinationFolderDetailView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 2.10.2023.
//

import SwiftUI

struct DestinationFolderDetailView: View {
    @StateObject var ViewModel: DestinationFolderDetailViewModel
    
    var body: some View {
        VStack {
            if ViewModel.Practices.isEmpty {
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
                List(ViewModel.Practices, id: \.id) { Practice in
                    NavigationLink(destination: VideoPlayerView(url: Practice.VideoPath)) {
                        HStack {
                            AsyncImage(url: URL.documentsDirectory.appending(path: Practice.ThumbPath ?? StringConstants.LVS)) { Image in
                                Image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 50, height: 50)
                                    .cornerRadius(5)
                            } placeholder: {
                                ProgressView()
                            }
                            VStack(alignment: .leading) {
                                Text(Practice.Name)
                                Text(Date.CurrentTime(From: Practice.UpdatedAt))
                                    .font(.subheadline)
                                    .foregroundStyle(.gray)
                            }
                        }
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


//#Preview {
//    DestinationFolderDetailView()
//}
