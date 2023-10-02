//
//  DestinationFolderDetailViewModel.swift
//  Folders
//
//  Created by Cengizhan Tomak on 2.10.2023.
//

import SwiftUI
import LVRealmKit

class DestinationFolderDetailViewModel: ObservableObject {
    @Published var ShowMoveAlert = false
    @Published var Session: SessionModel
    @Published var Practices: [PracticeModel] = []
    
    weak var DestinationFolderViewModel: DestinationFolderViewModel?
    
    init(Folder: SessionModel, DestinationFolderViewModel: DestinationFolderViewModel) {
        self.Session = Folder
        self.DestinationFolderViewModel = DestinationFolderViewModel
        LoadPractices()
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
    
    private func UpdatePracticeModel(PracticeModel: [PracticeModel]) {
        DispatchQueue.main.async { [weak self] in
            withAnimation(.spring()) {
                guard let self else { return }
                self.Practices = PracticeModel
            }
        }
    }
    
    func MovePractice() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.DestinationFolderViewModel?.SelectedFolder = self.Session
            self.DestinationFolderViewModel?.MovePractice()
        }
    }
}

