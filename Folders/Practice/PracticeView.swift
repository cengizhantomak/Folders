//
//  PracticeView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import CustomAlertPackage

struct PracticeView: View {
    @StateObject var ViewModel: PracticeViewModel
    @Environment(\.horizontalSizeClass) var horizontalSizeClass
    
    var body: some View {
        PracticeViewContent
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                Toolbars
            }
            .CustomAlert(
                IsPresented: $ViewModel.ShowRenameAlert,
                Title: Title(Text: StringConstants.Alert.Title.RenameVideo,
                             SystemImage: StringConstants.Alert.SystemImage.Pencil),
                TextField: TextFieldText(Placeholder: StringConstants.Alert.Title.VideoName,
                                         Text: $ViewModel.NewName),
                LabelLeft: LabelButton(Text: StringConstants.ContextMenu.AddFavorite.Text,
                                       SystemImage: ViewModel.PracticeFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage,
                                       Binding: $ViewModel.PracticeFavorite,
                                       Action: {
                                           ViewModel.PracticeFavorite.toggle()
                                       }),
                ButtonLeft: AlertButton(Text: StringConstants.Alert.ButtonText.Cancel,
                                        Action: {
                                            print("Cancel Tapped")
                                        }),
                ButtonRight: AlertButton(Text: StringConstants.Alert.ButtonText.Save,
                                         Action: {
                                             if !ViewModel.NewName.isEmpty {
                                                 ViewModel.RenamePractice()
                                             } else {
                                                 ViewModel.ErrorTTProgressHUD()
                                             }
                                         })
            )
            .CustomAlert(
                IsPresented: $ViewModel.ShowDeleteAlert,
                Title: Title(Text: StringConstants.Alert.Title.Deleting,
                             SystemImage: StringConstants.Alert.SystemImage.Trash),
                Message: StringConstants.Alert.Message.DeleteConfirmationMessage,
                ButtonLeft: AlertButton(Text: StringConstants.Alert.ButtonText.Cancel,
                                        Action: {
                                            print("Cancel Tapped")
                                        }),
                ButtonRight: AlertButton(Text: StringConstants.Alert.ButtonText.Delete,
                                         Action: {
                                             ViewModel.DeletePractices(ViewModel.SelectedPractices)
                                             ViewModel.IsSelecting = false
                                         })
            )
            .animation(.spring, value: [ViewModel.IsSelecting, ViewModel.OnlyShowFavorites])
            .onAppear {
                let ItemCount = ViewModel.NumberOfItemsPerRow(For: horizontalSizeClass)
                ViewModel.Columns = Array(repeating: GridItem(.flexible()), count: ItemCount)
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
            let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 1, Amount: CGFloat(ViewModel.Columns.count))
            ScrollView {
                Section(header: DateHeader) {
                    LazyVGrid(columns: ViewModel.Columns, spacing: 1) {
                        ForEach(ViewModel.DisplayedPractices, id: \.id) { Practice in
                            if !ViewModel.IsSelecting {
                                NavigationLink(destination: VideoPlayerView(url: Practice.VideoPath)) {
                                    PracticeItemView(ViewModel: ViewModel, Practice: Practice, ItemWidth: ItemWidth)
                                }
                                .foregroundColor(.primary)
                            } else {
                                PracticeItemView(ViewModel: ViewModel, Practice: Practice, ItemWidth: ItemWidth)
                                    .onTapGesture {
                                        if let Index = ViewModel.SelectedPractices.firstIndex(where: { $0.id == Practice.id }) {
                                            ViewModel.SelectedPractices.remove(at: Index)
                                        } else {
                                            ViewModel.SelectedPractices.append(Practice)
                                        }
                                    }
                                    .opacity(ViewModel.Opacity(For: Practice))
                            }
                        }
                    }
                }
                .padding(5)
            }
        }
    }
    
    // MARK: - Date Header
    private var DateHeader: some View {
        Text(Date.CurrentDate(From: ViewModel.Session.createdAt))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(.clear)
            .padding(.top)
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
