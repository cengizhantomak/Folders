//
//  PracticeItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import LVRealmKit

struct PracticeItemView: View {
    @StateObject var ViewModel: PracticeViewModel
    var Practice: PracticeModel
    let ItemWidth: CGFloat
    
    var body: some View {
        if !ViewModel.IsSelecting {
            PracticeItem
                .contextMenu {
                    VideoContextMenu
                }
            
                .alert(StringConstants.Alert.Title.RenameVideo, isPresented: $ViewModel.ShowRenameAlert) {
                    RenameVideoAlert
                }
            
                .alert(StringConstants.Alert.Title.Deleting, isPresented: $ViewModel.ShowDeleteAlert) {
                    DeleteVideoAlert
                } message: {
                    Text(StringConstants.Alert.Message.DeleteConfirmationMessage)
                }
        } else {
            PracticeItem
        }
    }
}

extension PracticeItemView {
    
    // MARK: - PracticeItem
    private var PracticeItem: some View {
        let CircleOffset = ViewModel.CircleOffset(For: ItemWidth, XOffsetValue: 20, YOffsetValue: 20)
        let SafeItemWidth = max(ItemWidth, 1)
        
        return ZStack {
            if let ThumbPath = Practice.ThumbPath {
//                Image(uiImage: UIImage(contentsOfFile: URL.documentsDirectory.appending(path: ThumbPath).path) ?? UIImage())
                AsyncImage(url: URL.documentsDirectory.appending(path: ThumbPath)) { Image in
                    Image
                        .resizable()
                        .frame(width: SafeItemWidth, height: SafeItemWidth * (16 / 9))
                        .scaledToFit()
                } placeholder: {
                    ProgressView()
                }
            } else {
                Rectangle()
                    .fill(Color.gray.opacity(0.15))
                    .frame(width: SafeItemWidth, height: SafeItemWidth * (16 / 9))
                    .cornerRadius(10)
                Image(systemName: StringConstants.SystemImage.RectangleStackBadgePlay)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SafeItemWidth * 0.3, height: SafeItemWidth * 0.3)
                    .foregroundColor(.gray)
            }
            VStack {
                Spacer()
                LinearGradient(colors: [Color.black, Color.clear], startPoint: .bottom, endPoint: .top)
                    .frame(height: 150)
            }
            .overlay(alignment: .leading) {
                PracticeNameAtBottom
            }
            FavoriteIcon(CircleOffset: CircleOffset, SafeItemWidth: SafeItemWidth)
            SelectionIcon(CircleOffset: CircleOffset)
        }
    }
    
    private var PracticeNameAtBottom: some View {
        VStack(alignment: .leading) {
            Spacer()
            Text(Practice.Name)
                .truncationMode(.tail)
                .lineLimit(1)
                .font(.system(size: 9, weight: .bold))
                .foregroundColor(.white)
            Text(Date.CurrentTime(From: Practice.UpdatedAt))
                .font(.system(size: 8))
                .foregroundColor(.gray)
        }
        .padding(5)
    }
    
    // MARK: - Icons
    private func FavoriteIcon(CircleOffset: (X: CGFloat, Y: CGFloat), SafeItemWidth: CGFloat) -> some View {
        Group {
            if Practice.isFavorite && !ViewModel.IsSelecting {
                Image(systemName: StringConstants.SystemImage.HeartFill)
                    .resizable()
                    .scaledToFit()
                    .frame(width: SafeItemWidth * 0.08, height: SafeItemWidth * 0.08)
                    .foregroundColor(.red)
                    .offset(x: CircleOffset.X, y: CircleOffset.Y)
            } else {
                EmptyView()
            }
        }
    }
    
    private func SelectionIcon(CircleOffset: (X: CGFloat, Y: CGFloat)) -> some View {
        Group {
            if ViewModel.IsSelecting {
                Circle()
                    .stroke(.gray, lineWidth: 2)
                    .background(Circle().fill(Color.white))
                    .overlay(
                        ViewModel.SelectedPractices.contains(where: { $0.id == Practice.id }) ?
                        Circle().stroke(.gray, lineWidth: 2).frame(width: 10, height: 10) : nil
                    )
                    .frame(width: 20, height: 20)
                    .offset(x: CircleOffset.X, y: CircleOffset.Y)
            } else {
                EmptyView()
            }
        }
    }
    
    // MARK: - Context Menu and Actions
    private var VideoContextMenu: some View {
        VStack {
            ToggleFavoriteButton
            SaveToPhoneButton
            MoveButton
            Divider()
            RenameVideoButton
            DeleteVideoButton
        }
    }
    
    private var ToggleFavoriteButton: some View {
        Button {
            ViewModel.Practice = Practice
            ViewModel.ToggleFavorite()
        } label: {
            Label(
                Practice.isFavorite ? StringConstants.ContextMenu.RemoveFavorite.Text : StringConstants.ContextMenu.AddFavorite.Text,
                systemImage: Practice.isFavorite ? StringConstants.ContextMenu.RemoveFavorite.SystemImage : StringConstants.ContextMenu.AddFavorite.SystemImage
            )
        }
    }
    
    private var SaveToPhoneButton: some View {
        Button {
            ViewModel.SaveToPhonePractice()
        } label: {
            Label(
                StringConstants.ContextMenu.SaveToPhone.Text,
                systemImage: StringConstants.ContextMenu.SaveToPhone.SystemImage
            )
        }
    }
    
    private var MoveButton: some View {
        Button {
            ViewModel.SelectedPractices.append(Practice)
            ViewModel.ShowBottomBarMoveAlert = true
        } label: {
            Label(
                StringConstants.ContextMenu.Move.Text,
                systemImage: StringConstants.ContextMenu.Move.SystemImage
            )
        }
    }
    
    private var RenameVideoButton: some View {
        Button {
            ViewModel.Practice = Practice
            ViewModel.NewName = Practice.Name
            ViewModel.ShowRenameAlert = true
        } label: {
            Label(
                StringConstants.ContextMenu.Rename.Text,
                systemImage: StringConstants.ContextMenu.Rename.SystemImage
            )
        }
    }
    
    private var DeleteVideoButton: some View {
        Button(role: .destructive) {
            ViewModel.SelectedPractices.append(Practice)
            ViewModel.ShowDeleteAlert = true
        } label: {
            Label(
                StringConstants.ContextMenu.Delete.Text,
                systemImage: StringConstants.ContextMenu.Delete.SystemImage
            )
        }
    }
    
    // MARK: - Alerts
    private var RenameVideoAlert: some View {
        Group {
            TextField(StringConstants.Alert.Title.VideoName, text: $ViewModel.NewName)
            Button(StringConstants.Alert.ButtonText.Save, role: .destructive) {
                if !ViewModel.NewName.isEmpty {
                    ViewModel.RenamePractice()
                } else {
                    ViewModel.ErrorTTProgressHUD()
                }
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                print("Cancel Tapped")
            }
        }
    }
    
    private var DeleteVideoAlert: some View {
        Group {
            Button(StringConstants.Alert.ButtonText.Delete, role: .destructive) {
                ViewModel.DeletePractices(ViewModel.SelectedPractices)
            }
            Button(StringConstants.Alert.ButtonText.Cancel, role: .cancel) {
                ViewModel.SelectedPractices.removeAll()
                print("Cancel Tapped")
            }
        }
    }
}

//struct PracticeItemView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeItemView(ViewModel: PracticeViewModel(Folder: FolderModel(Name: "LVS")), Practice: VideoModel(), ItemWidth: 100)
//    }
//}
