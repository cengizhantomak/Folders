//
//  ContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var Folders: [FolderModel] = []
    @State private var ShowAlert: Bool = false
    @State private var InputName: String = ""
    
    let Columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func CurrentDateTime() -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "yyyyMMdd-HHmmssSSS"
        return Formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { Geometry in
                let ScreenWidth = Geometry.size.width
                let ItemWidth = (ScreenWidth - 30) / 2
                ScrollView {
                    LazyVGrid(columns: Columns, spacing: 10) {
                        ForEach(Folders) { Folder in
                            FolderItemView(Folder: Folder, ItemWidth: ItemWidth)
                                .onTapGesture {
                                    if let Index = Folders.firstIndex(where: { $0.id == Folder.id }) {
                                        Folders.remove(at: Index)
                                    }
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
                .alert("Create Folder", isPresented: $ShowAlert) {
                    TextField("name", text: $InputName)
                    Button("Save", role: .destructive) {
                        withAnimation(Animation.easeInOut(duration: 0.2)) {
                            Folders.insert(FolderModel(Name: InputName), at: 0)
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        print("Cancel Tapped")
                    }
                }
            }
        }
    }
    
    private func AddButtonAction() {
        InputName = CurrentDateTime()
        ShowAlert = true
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
