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
    @State var HudConfigSuccess = TTProgressHUDConfig(type: .success ,shouldAutoHide: true, autoHideInterval: 0.7)
    @State var HudConfigError = TTProgressHUDConfig(type: .error, shouldAutoHide: true, autoHideInterval: 0.7)
    
    var body: some View {
        ZStack {
            VStack {
                if ViewModel.Videos.isEmpty {
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
                    GeometryReader { Geometry in
                        let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 8, Amount: 3)
                        ZStack {
                            ScrollView {
                                VStack {
                                    VideoGridView(ViewModel: ViewModel, ItemWidth: ItemWidth)
                                }
                                .padding(5)
                            }
                            VStack {
                                HStack {
                                    Text(ViewModel.Folder.Name)
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.5)
                                        .font(.title2)
                                        .background(Color.clear)
                                        .padding(16)
                                        .frame(alignment: .leading)
                                    Spacer(minLength: 100)
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
                            ViewModel.ShowBottomBarDeleteAlert = true
                        } label: {
                            Image(systemName: StringConstants.SystemImage.Trash)
                                .foregroundColor(ViewModel.SelectedVideos.isEmpty ? .gray : .primary)
                        }
                        .disabled(ViewModel.SelectedVideos.isEmpty)
                    }
                }
            }
            .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowBottomBarDeleteAlert) {
                Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                    for Video in ViewModel.SelectedVideos {
                        ViewModel.RemoveVideo(For: Video)
                    }
                    ViewModel.SelectedVideos.removeAll()
                    ViewModel.IsSelecting.toggle()
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Cancel Tapped")
                }
            } message: {
                Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
            }
            TTProgressHUD($ViewModel.IsSuccessTTProgressHUDVisible, config: HudConfigSuccess)
                .scaleEffect(0.5)
            TTProgressHUD($ViewModel.IsErrorTTProgressHUDVisible, config: HudConfigError)
                .scaleEffect(0.5)
        }
    }
}

struct VideoView_Previews: PreviewProvider {
    static var previews: some View {
        VideoView(ViewModel: VideoViewModel(Folder: FolderModel(Name: "LVS")))
    }
}
