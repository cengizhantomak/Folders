//
//  VideoView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import TTProgressHUD

struct VideoView: View {
    @StateObject var ViewModel: VideoViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if ViewModel.Videos.isEmpty {
                    VStack {
                        Spacer()
                        Image(systemName: "video.slash")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 50, height: 50)
                        
                        Text("No Video")
                            .font(.system(size: 15))
                        Spacer()
                    }
                    .foregroundColor(.gray)
                    .ignoresSafeArea(.all)
                } else {
                    GeometryReader { Geometry in
                        let ScreenWidth = Geometry.size.width
                        let ItemWidth = (ScreenWidth - 20) / 3
                        ZStack {
                            ScrollView {
                                LazyVStack {
                                    VideoGridView(ViewModel: ViewModel, ItemWidth: ItemWidth)
                                }
                                .padding(5)
                            }
                            VStack {
                                HStack {
                                    Text(ViewModel.Folder.Name)
                                        .font(.title2)
                                        .background(Color.clear)
                                        .padding(16)
                                        .frame(alignment: .leading)
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }
            }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                if !ViewModel.IsSelecting {
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
                        Text(ViewModel.SelectionCount(For: ViewModel.SelectedVideos.count))
                            .foregroundColor(ViewModel.SelectedVideos.isEmpty ? .gray : .primary)
                        Spacer()
                        Button {
                            if !ViewModel.SelectedVideos.isEmpty {
                                ViewModel.ShowBottomBarDeleteAlert = true
                            }
                        } label: {
                            Image(systemName: StringConstants.SystemImage.Trash)
                                .foregroundColor(ViewModel.SelectedVideos.isEmpty ? .gray : .primary)
                        }
                    }
                }
            }
            .alert(isPresented: $ViewModel.ShowBottomBarDeleteAlert) {
                Alert(
                    title: Text(StringConstants.Alert.Title.Deleting),
                    message: Text(StringConstants.Alert.Message.DeleteConfirmationMessage),
                    primaryButton: .destructive(Text(StringConstants.Alert.ButtonText.Delete)) {
                        for Video in ViewModel.SelectedVideos {
                            ViewModel.RemoveVideo(For: Video)
                        }
                        ViewModel.SelectedVideos.removeAll()
                        ViewModel.IsSelecting.toggle()
                    },
                    secondaryButton: .cancel()
                )
            }
            TTProgressHUD($ViewModel.IsTTProgressHUDVisible, type: .success)
                .scaleEffect(0.5)
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")))
    }
}
