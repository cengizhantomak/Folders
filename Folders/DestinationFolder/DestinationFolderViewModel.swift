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
    @Published var SelectedPractices: [PracticeModel] = []
    @Published var SelectedFolder: SessionModel?
    @Published var ShowMoveAlert = false
    weak var PracticeViewModel: PracticeViewModel?
    
    init(SelectedPractices: [PracticeModel], PracticeViewModel: PracticeViewModel) {
        self.SelectedPractices = SelectedPractices
        self.PracticeViewModel = PracticeViewModel
        LoadFolders()
    }
    
    private func UpdateSessionModel(SessionModel: [SessionModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                if let sessionID = self.SelectedPractices.first?.Session?.id {
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
                
                SelectedPractices.forEach { Practice in
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
            self.PracticeViewModel?.SelectCancelButtonAction()
            self.PracticeViewModel?.ShowBottomBarMoveAlert = false
            self.PracticeViewModel?.SuccessTTProgressHUD()
        }
    }
}
