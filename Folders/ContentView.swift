//
//  ContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var ViewModel = FolderViewModel()
    @State private var BottomBarDeleteShowAlert = false
    
    let Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationView {
            GeometryReader { Geometry in
                let ScreenWidth = Geometry.size.width
                let ItemWidth = (ScreenWidth - 30) / 2
                ScrollView {
                    VStack(alignment: .leading, spacing: 20) {
                        CreateSection(WithTitle: "Pinned", Folders: ViewModel.PinnedFolders, ItemWidth: ItemWidth)
                        CreateSection(WithTitle: "Todays", Folders: ViewModel.TodayFolders, ItemWidth: ItemWidth)
                        CreateSection(WithTitle: "Session", Folders: ViewModel.SessionFolders, ItemWidth: ItemWidth)
                    }
                    .padding(10)
                }
                .navigationTitle("Videos")
                .toolbar {
                    if !ViewModel.isSelecting {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: AddButtonAction) {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Circle())
                            }
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: FavoritesButtonAction) {
                                Image(systemName: "heart")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Circle())
                            }
                            Button(action: SelectCancelButtonAction) {
                                Text(ViewModel.isSelecting ? "Cancel" : "Select")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Capsule())
                            }
                        }
                    } else {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button(action: SelectCancelButtonAction) {
                                Text("Cancel")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Capsule())
                            }
                        }
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Text("Select Items")
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                if !ViewModel.selectedFolders.isEmpty {
                                    BottomBarDeleteShowAlert = true
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                }
                .alert("Create Folder", isPresented: $ViewModel.ShowAlert) {
                    TextField("name", text: $ViewModel.InputName)
                    Button("Save", role: .destructive) {
                        ViewModel.AddFolder()
                    }
                    Button("Cancel", role: .cancel) {
                        print("Cancel Tapped")
                    }
                }
                .alert(isPresented: $BottomBarDeleteShowAlert) {
                    Alert(
                        title: Text("Deleting!"),
                        message: Text("Are you sure you want to delete the selected folders?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            for folder in ViewModel.selectedFolders {
                                ViewModel.RemoveFolder(for: folder)
                            }
                            ViewModel.selectedFolders.removeAll()
                            ViewModel.isSelecting.toggle()
                        }),
                        secondaryButton: .cancel()
                    )
                }
            }
        }
    }
    
    private func CreateSection(WithTitle Title: String, Folders: [FolderModel], ItemWidth: CGFloat) -> some View {
        Group {
            if !Folders.isEmpty {
                VStack(alignment: .leading) {
                    Divider()
                    Section(header: Text(Title).font(.headline)) {
                        LazyVGrid(columns: Columns, spacing: 10) {
                            ForEach(Folders) { Folder in
                                FolderItemView(Folder: Folder, ItemWidth: ItemWidth, ViewModel: ViewModel)
                                    .onTapGesture {
                                        if ViewModel.isSelecting {
                                            if ViewModel.selectedFolders.contains(where: { $0.id == Folder.id }) {
                                                if let index = ViewModel.selectedFolders.firstIndex(where: { $0.id == Folder.id }) {
                                                    ViewModel.selectedFolders.remove(at: index)
                                                }
                                            } else {
                                                ViewModel.selectedFolders.append(Folder)
                                            }
                                        } else {
                                            ViewModel.RemoveFolder(for: Folder)
                                        }
                                    }
                                    .opacity(ViewModel.isSelecting && !ViewModel.selectedFolders.contains(where: { $0.id == Folder.id }) ? 0.5 : 1.0)
                            }
                        }
                    }
                }
            }
        }
    }
    
    private func AddButtonAction() {
        ViewModel.InputName = DateHelper.CurrentDateTime()
        ViewModel.ShowAlert = true
    }
    
    private func SelectCancelButtonAction() {
        ViewModel.isSelecting.toggle()
        if !ViewModel.isSelecting {
            ViewModel.selectedFolders.removeAll()
        }
    }
    
    private func FavoritesButtonAction() {
        // TODO: Favorites Button
        print("Favorites Tapped")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
