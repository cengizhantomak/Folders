//
//  PracticeView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct PracticeView: View {
    @StateObject var ViewModel: PracticeViewModel
    
    var body: some View {
        ZStack {
            VStack {
                if ViewModel.Practices.isEmpty {
                    ZStack {
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
                    }
                } else {
                    GeometryReader { Geometry in
                        let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 1, Amount: 3)
                        ScrollView {
                            PracticeGridView(ViewModel: ViewModel, ItemWidth: ItemWidth)
                                .padding(5)
                        }
                    }
                }
            }
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
                            ViewModel.ShowBottomBarDeleteAlert = true
                        } label: {
                            Image(systemName: StringConstants.SystemImage.Trash)
                                .foregroundColor(ViewModel.SelectedPractices.isEmpty ? .gray : .primary)
                        }
                        .disabled(ViewModel.SelectedPractices.isEmpty)
                    }
                }
            }
            .sheet(isPresented: $ViewModel.ShowBottomBarMoveAlert) {
                DestinationFolderView(ViewModel: DestinationFolderViewModel(SelectedPractices: ViewModel.SelectedPractices))
            }
            .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowBottomBarDeleteAlert) {
                Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                    ViewModel.DeletePractices(ViewModel.SelectedPractices)
                    ViewModel.IsSelecting = false
                }
                Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                    print("Cancel Tapped")
                }
            } message: {
                Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
            }
        }
        .overlay {
            CustomTTProgressHUD(IsSuccessVisible: $ViewModel.IsSuccessTTProgressHUDVisible, IsErrorVisible: $ViewModel.IsErrorTTProgressHUDVisible)
        }
    }
}

//struct PracticeView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeView(ViewModel: PracticeViewModel(Folder: FolderModel(Name: "LVS")))
//    }
//}
