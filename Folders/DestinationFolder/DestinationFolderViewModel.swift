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
                
                let LatestPractice = SelectedPractices.max(by: { $0.CreatedAt < $1.CreatedAt })
                
                if var DestinationFolder = SelectedFolder {
                    DestinationFolder.practiceCount += SelectedPractices.count
                    DestinationFolder.thumbnail = LatestPractice?.ThumbPath
                    try await FolderRepository.shared.edit(DestinationFolder)
                }
                
                if var FolderOfSelectedPractices = self.SelectedPractices.first?.Session {
                    FolderOfSelectedPractices.practiceCount -= SelectedPractices.count
                    try await FolderRepository.shared.edit(FolderOfSelectedPractices)
                }
                
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.PracticeViewModel?.LoadPractices()
                    self.PracticeViewModel?.SelectCancelButtonAction()
                    self.PracticeViewModel?.ShowBottomBarMoveAlert = false
                }
            } catch {
                print("Error updating practice status: \(error)")
            }
        }
    }
}
