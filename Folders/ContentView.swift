//
//  ContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var ViewModel = FolderViewModel()
    
    var body: some View {
        NavigationView {
            GeometryReader { Geometry in
                let ItemWidth = ViewModel.CalculateItemWidth(ScreenWidth: Geometry.size.width, Padding: 30, Amount: 2)
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
                    if !ViewModel.IsSelecting {
                        ToolbarItem(placement: .navigationBarLeading) {
                            Button(action: ViewModel.AddButtonAction) {
                                Image(systemName: "plus")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Circle())
                            }
                        }
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: ViewModel.FavoritesButtonAction) {
                                Image(systemName: "heart")
                                    .foregroundColor(.black)
                                    .padding(8)
                                    .background(Color.gray.opacity(0.25))
                                    .clipShape(Circle())
                            }
                        }
                    } else {
                        ToolbarItemGroup(placement: .bottomBar) {
                            Spacer()
                            Text("Select Items")
                                .foregroundColor(.gray)
                            Spacer()
                            Button(action: {
                                if !ViewModel.SelectedFolders.isEmpty {
                                    ViewModel.ShowBottomBarDeleteAlert = true
                                }
                            }) {
                                Image(systemName: "trash")
                                    .foregroundColor(.gray)
                            }
                        }
                    }
                    ToolbarItemGroup(placement: .navigationBarTrailing) {
                        Button(action: ViewModel.SelectCancelButtonAction) {
                            Text(ViewModel.IsSelecting ? "Cancel" : "Select")
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Color.gray.opacity(0.25))
                                .clipShape(Capsule())
                        }
                    }
                }
                .alert("Create Folder", isPresented: $ViewModel.ShowCreatedAlert) {
                    TextField("name", text: $ViewModel.InputName)
                    Button("Save", role: .destructive) {
                        ViewModel.AddFolder()
                    }
                    Button("Cancel", role: .cancel) {
                        print("Cancel Tapped")
                    }
                }
                .alert(isPresented: $ViewModel.ShowBottomBarDeleteAlert) {
                    Alert(
                        title: Text("Deleting!"),
                        message: Text("Are you sure you want to delete the selected folders?"),
                        primaryButton: .destructive(Text("Delete"), action: {
                            for Folder in ViewModel.SelectedFolders {
                                ViewModel.RemoveFolder(For: Folder)
                            }
                            ViewModel.SelectedFolders.removeAll()
                            ViewModel.IsSelecting.toggle()
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
                    SectionTitleView(Title: Title)
                    FolderGridView(ViewModel: ViewModel, Folders: Folders, ItemWidth: ItemWidth)
                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
