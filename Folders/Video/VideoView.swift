//
//  VideoView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct VideoView: View {
    @StateObject var ViewModel: VideoViewModel
    
    var body: some View {
        GeometryReader { Geometry in
            let ScreenWidth = Geometry.size.width
            let ItemWidth = (ScreenWidth - 20) / 3
            ScrollView {
                LazyVGrid(columns: ViewModel.Columns, spacing: 5) {
                    ForEach(ViewModel.Videos.sorted(by: { $0.CreationDate > $1.CreationDate })) { Video in
                        VideoItemView(ViewModel: ViewModel, Video: Video, ItemWidth: ItemWidth)
                            .onTapGesture {
                                if ViewModel.IsSelecting {
                                    if ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) {
                                        if let Index = ViewModel.SelectedVideos.firstIndex(where: { $0.id == Video.id }) {
                                            ViewModel.SelectedVideos.remove(at: Index)
                                        }
                                    } else {
                                        ViewModel.SelectedVideos.append(Video)
                                    }
                                } else {
                                    ViewModel.RemoveVideo(For: Video)
                                }
                            }
                            .opacity(ViewModel.IsSelecting && !ViewModel.SelectedVideos.contains(where: { $0.id == Video.id }) ? 0.5 : 1.0)
                    }
                }
                .padding(5)
            }
            .navigationTitle(ViewModel.Folder.Name)
            .toolbar {
                if !ViewModel.IsSelecting {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        HStack(spacing: 0) {
                            Button {
                                ViewModel.AddVideo()
                            } label: {
                                Image(systemName: StringConstants.SystemImage.Plus)
                                    .foregroundColor(.primary)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Circle())
                            }
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
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")))
    }
}