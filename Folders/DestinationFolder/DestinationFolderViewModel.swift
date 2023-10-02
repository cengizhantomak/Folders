//
//  DestinationFolderViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 29.09.2023.
//

import SwiftUI
import LVRealmKit

class DestinationFolderViewModel: ObservableObject {
    @Published var Sessions: [SessionModel] = []
    @Published var SelectedFolder: SessionModel?
    @Published var ShowMoveAlert = false
    @Published var ShowCreatedAlert = false
    @Published var IsSuccessTTProgressHUDVisible = false
    @Published var IsErrorTTProgressHUDVisible = false
    @Published var FolderName = ""
    var FolderCreationDate: Date?
    weak var PracticeViewModel: PracticeViewModel?
    
    init(PracticeViewModel: PracticeViewModel) {
        self.PracticeViewModel = PracticeViewModel
        LoadFolders()
    }
    
    private func UpdateSessionModel(SessionModel: [SessionModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                if let sessionID = self.PracticeViewModel?.Session.id {
                    let updatedSessions = SessionModel.filter { session in
                        sessionID != session.id
                    }
                    self.Sessions = updatedSessions
                }
            }
        }
    }
    
    func LoadFolders() {
        Task {
            do {
                let AllSessions = try await FolderRepository.shared.getFolders()
                UpdateSessionModel(SessionModel: AllSessions)
            } catch {
                print("Error loading sessions: \(error)")
            }
        }
    }
    
    func MovePractice() {
        Task {
            do {
                var UpdatedPracticesArray: [PracticeModel] = []
                
                PracticeViewModel?.SelectedPractices.forEach { Practice in
                    var UpdatedPractice = Practice
                    UpdatedPractice.Session = SelectedFolder
                    UpdatedPracticesArray.append(UpdatedPractice)
                }
                
                try await PracticeRepository.shared.edit(UpdatedPracticesArray)
                try await UpdateDestinationFolder()
                UpdateUI()
            } catch {
                print("Error updating practice status: \(error)")
            }
        }
    }
    
    private func UpdateDestinationFolder() async throws {
        if var DestinationFolder = SelectedFolder {
            let Practices = try await PracticeRepository.shared.getPractices(DestinationFolder)
            // DestinationFolder içindeki Practice sayısını güncelle
            DestinationFolder.practiceCount = Practices.count
            // DestinationFolder'ın thumbnail'ını güncelle
            if let LastPractice = Practices.first {
                DestinationFolder.thumbnail = LastPractice.ThumbPath
            }
            try await FolderRepository.shared.edit(DestinationFolder)
        }
    }
    
    private func UpdateUI() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.PracticeViewModel?.LoadPractices()
            self.PracticeViewModel?.IsSelecting = false
            self.PracticeViewModel?.ShowBottomBarMoveAlert = false
            self.PracticeViewModel?.SuccessTTProgressHUD()
        }
    }
    
    func AddButtonAction() {
        FolderCreationDate = Date()
        FolderName = FolderCreationDate?.dateFormat(StringConstants.DateTimeFormatFolder) ?? StringConstants.LVS
        ShowCreatedAlert = true
    }
    
    func AddFolder() {
        Task {
            do {
                var Folder = SessionModel()
                Folder.name = FolderName
                Folder.createdAt = FolderCreationDate ?? Date()
                try await FolderRepository.shared.addFolder(Folder)
                LoadFolders()
                SuccessTTProgressHUD()
            } catch {
                print("Error adding session: \(error)")
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
}
