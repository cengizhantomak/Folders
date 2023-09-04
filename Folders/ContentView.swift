//
//  ContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @StateObject var ViewModel = FolderViewModel()
    
    let Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        NavigationStack {
            GeometryReader { Geometry in
                let ScreenWidth = Geometry.size.width
                let ItemWidth = (ScreenWidth - 30) / 2
                ScrollView {
                    LazyVGrid(columns: Columns, spacing: 10) {
                        ForEach(ViewModel.Folders) { Folder in
                            FolderItemView(Folder: Folder, ItemWidth: ItemWidth)
                                .onTapGesture {
                                    ViewModel.RemoveFolder(withId: Folder.id)
                                }
                        }
                    }
                    .padding(10)
                }
                .navigationTitle("Videos")
                .toolbar {
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
                        Button(action: SelectButtonAction) {
                            Text("Select")
                                .foregroundColor(.black)
                                .padding(8)
                                .background(Color.gray.opacity(0.25))
                                .clipShape(Capsule())
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
            }
        }
    }
    
    private func AddButtonAction() {
        ViewModel.InputName = DateHelper.CurrentDateTime()
        ViewModel.ShowAlert = true
    }
    
    private func SelectButtonAction() {
        // TODO: Select Button
        print("Select Tapped")
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
