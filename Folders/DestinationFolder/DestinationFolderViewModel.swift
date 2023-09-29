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
    
    init(SelectedPractices: [PracticeModel]) {
        self.SelectedPractices = SelectedPractices
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
                var updatedPracticesArray: [PracticeModel] = []
                
                SelectedPractices.forEach { practice in
                    var updatedPractice = practice
                    updatedPractice.Session = SelectedFolder
                    updatedPracticesArray.append(updatedPractice)
                }
                
                try await PracticeRepository.shared.edit(updatedPracticesArray)
                
                let latestPractice = SelectedPractices.max(by: { $0.CreatedAt < $1.CreatedAt })
                
                if var Folder = SelectedFolder {
                    Folder.practiceCount += SelectedPractices.count
                    Folder.thumbnail = latestPractice?.ThumbPath
                    try await FolderRepository.shared.edit(Folder)
                }
            } catch {
                print("Error updating practice status: \(error)")
            }
        }
    }
}
