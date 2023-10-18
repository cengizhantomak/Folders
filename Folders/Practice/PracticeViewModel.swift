//
//  PracticeViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI
import LVRealmKit

class PracticeViewModel: ObservableObject {
    @Published var Columns: [GridItem] = []
    @Published var IsSelecting = false
    @Published var OnlyShowFavorites = false
    @Published var ShowMoveAlert = false
    @Published var ShowRenameAlert = false
    @Published var ShowDeleteAlert = false
    @Published var IsSuccessTTProgressHUDVisible = false
    @Published var IsErrorTTProgressHUDVisible = false
    @Published var Session: SessionModel
    @Published var SelectedPractices: [PracticeModel] = []
    @Published var Practice: PracticeModel?
    @Published var NewName = ""
    @Published var PracticeFavorite = false
    @Published var ClampedOpacity: CGFloat = 0.0
    @Published var isActive = false
    var DisplayedPractices: [PracticeModel] = []
    var Practices: [PracticeModel] = [] {
        didSet {
            self.DisplayedPractices = OnlyShowFavorites ? Practices.filter { $0.isFavorite } : Practices
        }
    }
    
    init(Folder: SessionModel) {
        self.Session = Folder
        LoadPractices()
    }
    
    func LoadPractices() {
        Task {
            do {
                try await GetPractices()
            } catch {
                print("Failed to load practices: \(error)")
            }
        }
    }
    
    func GetPractices() async throws {
        let AllPractices = try await PracticeRepository.shared.getPractices(Session)
        try await UpdateSession(AllPractices)
        UpdatePracticeModel(PracticeModel: AllPractices)
    }
    
    private func UpdateSession(_ AllPractices: [PracticeModel]) async throws {
        var UpdateSession = self.Session
        // Session içindeki Practice sayısını güncelle
        UpdateSession.practiceCount = AllPractices.count
        
        // Session'ın thumbnail'ını güncelle
        if let LastPractice = AllPractices.first {
            UpdateSession.thumbnail = LastPractice.ThumbPath
        } else {
            UpdateSession.thumbnail = nil
        }
        
        try await FolderRepository.shared.edit(UpdateSession)
    }
    
    private func UpdatePracticeModel(PracticeModel: [PracticeModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation {
                guard let self else { return }
                self.Session.practiceCount = PracticeModel.count
                self.Practices = PracticeModel
                self.SelectedPractices.removeAll()
                self.Practice = nil
            }
        }
    }
    
    func SaveToPhonePractice() {
        print("Save to Phone Tapped")
        SuccessTTProgressHUD()
    }
    
    func RenamePractice() {
        Task {
            do {
                if var Video = self.Practice {
                    Video.Name = NewName
                    Video.isFavorite = PracticeFavorite
                    try await PracticeRepository.shared.edit(Video)
                }
                try await GetPractices()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
        SuccessTTProgressHUD()
    }
    
    func DeletePractices(_ DeletePractice: [PracticeModel]) {
        Task {
            do {
                try await PracticeRepository.shared.deletePractices(DeletePractice)
                try await GetPractices()
            } catch {
                print("Error deleting session: \(error)")
            }
        }
        SuccessTTProgressHUD()
    }
    
    func FavoritesButtonAction() {
        isActive = true
        withAnimation { [weak self] in
            guard let self else { return }
            self.OnlyShowFavorites.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isActive = false
        }
        DisplayedPractices = OnlyShowFavorites ? Practices.filter { $0.isFavorite } : Practices
    }
    
    func ToggleFavorite() {
        Task {
            do {
                if var Video = Practice {
                    Video.isFavorite.toggle()
                    try await PracticeRepository.shared.edit(Video)
                }
                try await GetPractices()
            } catch {
                print("Error updating favorite status: \(error)")
            }
        }
        SuccessTTProgressHUD()
    }
    
    func SelectCancelButtonAction() {
        isActive = true
        withAnimation { [weak self] in
            guard let self else { return }
            self.IsSelecting.toggle()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            guard let self else { return }
            self.isActive = false
        }
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
    
    func SuccessTTProgressHUD() {
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
    
    func UpdateClampedOpacity(With Proxy: GeometryProxy, Name: String) {
        let Offset = -Proxy.frame(in: .named(Name)).origin.y
        let NormalizedOpacity = (Offset - 10) / (110 - 10)
        ClampedOpacity = min(max(NormalizedOpacity, 0), 1) * 0.75
    }
    
    func SetupColumnsToDevice(To SizeClass: UserInterfaceSizeClass?) {
        let ItemCount: Int
        if SizeClass == .compact {
            ItemCount = 2 //iPhone
        } else {
            ItemCount = 4 //iPad
        }
        Columns = Array(repeating: GridItem(.flexible()), count: ItemCount)
    }
}
