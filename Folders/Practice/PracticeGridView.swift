//
//  PracticeGridView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 12.09.2023.
//

import SwiftUI
import LVRealmKit

struct PracticeGridView: View {
    @StateObject var ViewModel: PracticeViewModel
    let ItemWidth: CGFloat
    
    var body: some View {
        Section(header: DateHeader) {
            LazyVGrid(columns: ViewModel.Columns, spacing: 1) {
                ForEach(ViewModel.Practices, id: \.self) { Practice in
                    if !ViewModel.IsSelecting {
                        PracticeItemView(ViewModel: ViewModel, Practice: Practice, ItemWidth: ItemWidth)
                    } else {
                        SelectablePracticeItem(For: Practice)
                    }
                }
            }
        }
    }
}

extension PracticeGridView {
    
    // MARK: - Date Header
    private var DateHeader: some View {
        Text(Date.CurrentDate(From: ViewModel.Session.createdAt))
            .foregroundColor(.gray)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(.clear)
            .padding(.top)
    }
    
    // MARK: - Selectable Practice Item
    private func SelectablePracticeItem(For Practice: PracticeModel) -> some View {
        PracticeItemView(ViewModel: ViewModel, Practice: Practice, ItemWidth: ItemWidth)
            .onTapGesture {
                HandlePracticeSelection(Of: Practice)
            }
            .opacity(ViewModel.Opacity(For: Practice))
    }
    
    // MARK: Selection Handling
    private func HandlePracticeSelection(Of Practice: PracticeModel) {
        if let Index = ViewModel.SelectedPractices.firstIndex(where: { $0.id == Practice.id }) {
            ViewModel.SelectedPractices.remove(at: Index)
        } else {
            ViewModel.SelectedPractices.append(Practice)
        }
    }
}

//struct PracticeGridView_Previews: PreviewProvider {
//    static var previews: some View {
//        PracticeGridView(ViewModel: PracticeViewModel(Folder: FolderModel(Name: "LVS")), ItemWidth: 150)
//    }
//}
