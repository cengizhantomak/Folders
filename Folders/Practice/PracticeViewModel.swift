//
//  PracticeViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import LVRealmKit

class PracticeViewModel: ObservableObject {
    var Columns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    @Published var IsSelecting = false
    @Published var ShowBottomBarDeleteAlert = false
    @Published var ShowBottomBarMoveAlert = false
    @Published var OnlyShowFavorites = false
    @Published var ShowMoveAlert = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var IsSuccessTTProgressHUDVisible = false
    @Published var IsErrorTTProgressHUDVisible = false
    var Session: SessionModel
    var Practices: [PracticeModel] = []
    @Published var SelectedPractices: [PracticeModel] = []
    @Published var Practice: PracticeModel?
    @Published var NewName = ""
    
    init(Folder: SessionModel) {
        self.Session = Folder
        LoadPractices()
    }
    
    private func UpdatePracticeModel(PracticeModel: [PracticeModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Practices = PracticeModel
                self.SelectedPractices.removeAll()
                self.Practice = nil
            }
        }
    }
    
    func LoadPractices() {
        Task {
            do {
                let AllPractices = try await PracticeRepository.shared.getPractices(Session)
                UpdatePracticeModel(PracticeModel: AllPractices)
            } catch {
                print("Failed to load practices: \(error)")
            }
        }
    }
    
    private func SuccessTTProgressHUD() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.IsSuccessTTProgressHUDVisible = true
        }
    }
    
    func ErrorTTProgressHUD() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.IsErrorTTProgressHUDVisible = true
        }
    }
    
    func SaveToPhonePractice() {
        print("Save to Phone Tapped")
        SuccessTTProgressHUD()
    }
    
    func MovePractice() {
        print("Move Tapped")
        SuccessTTProgressHUD()
    }
    
    func RenamePractice(NewName: String) {
        Task {
            do {
                if var Video = Practice {
                    Video.Name = NewName
                    try await PracticeRepository.shared.edit(Video)
                }
                LoadPractices()
                SuccessTTProgressHUD()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func DeletePractices(_ DeletePractice: [PracticeModel]) {
        Task {
            do {
                try await PracticeRepository.shared.deletePractices(DeletePractice)
                
                LoadPractices()
                SuccessTTProgressHUD()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
        UpdatePractice(DeletePractice)
    }
    
    func UpdatePractice(_ UpdatePractice: [PracticeModel]) {
        Task {
            do {
                let UpdatedArray = Practices.filter { Practice in
                    !UpdatePractice.contains(where: { $0.id == Practice.id })
                }
                
                let CurrentThumb = UpdatedArray.first?.ThumbPath
                
                if var Video = Practice {
                    Video.Session?.practiceCount = UpdatedArray.count
                    Video.Session?.thumbnail = CurrentThumb
                    try await PracticeRepository.shared.edit(Video)
                }
                
                LoadPractices()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func FavoritesButtonAction() {
        if OnlyShowFavorites {
            OnlyShowFavorites.toggle()
            LoadPractices()
        } else {
            withAnimation(.spring()) { [weak self] in
                guard let self else { return }
                self.Practices = self.Practices.filter { $0.isFavorite }
            }
            OnlyShowFavorites.toggle()
        }
    }
    
    func ToggleFavorite() {
        Task {
            do {
                if var Video = Practice {
                    Video.isFavorite.toggle()
                    try await PracticeRepository.shared.edit(Video)
                }
                LoadPractices()
                SuccessTTProgressHUD()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
    }
    
    func SelectCancelButtonAction() {
        IsSelecting.toggle()
        if !IsSelecting {
            SelectedPractices.removeAll()
        }
    }
    
    func SelectionCount(For Count: Int) -> String {
        switch Count {
        case 0:
            return StringConstants.SelectItems
        case 1:
            return StringConstants.OneVideoSelected
        default:
            return String(format: StringConstants.MultipleVideosSelected, Count)
        }
    }
    
    func CircleOffset(For ItemWidth: CGFloat, XOffsetValue: CGFloat = 20, YOffsetValue: CGFloat = 20) -> (X: CGFloat, Y: CGFloat) {
        let X = (ItemWidth / 2) - XOffsetValue
        let Y = -(ItemWidth * (16 / 9) / 2) + YOffsetValue
        return (X, Y)
    }
    
    func CalculateItemWidth(ScreenWidth: CGFloat, Padding: CGFloat, Amount: CGFloat) -> CGFloat {
        return (ScreenWidth - (Padding * (Amount + 1))) / Amount
    }
    
    func Opacity(For Practice: PracticeModel) -> Double {
        return IsSelecting && !SelectedPractices.contains(where: { $0.id == Practice.id }) ? 0.5 : 1.0
    }
}
