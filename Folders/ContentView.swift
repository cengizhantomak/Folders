//
//  ContentView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

struct ContentView: View {
    @State private var views: [String] = []
    @State private var showAlert: Bool = false
    @State private var inputName: String = ""
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    func currentDateTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd-HHmmssSSS"
        return formatter.string(from: Date())
    }
    
    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                let ekranGenislik = geometry.size.width
                let itemGenislik = (ekranGenislik - 30) / 2
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(views, id: \.self) { name in
                            VStack(alignment: .leading) {
                                Rectangle()
                                    .fill(Color.gray)
                                    .frame(width: itemGenislik, height: itemGenislik * 1.5)
                                    .cornerRadius(10)
                                
                                Text(name)
                                    .font(.system(size: 15))
                            }
                            .onTapGesture {
                                if let index = views.firstIndex(of: name) {
                                    views.remove(at: index)
                                }
                            }
                        }
                    }
                    .padding(10)
                }
                
                .navigationTitle("Videos")
                .navigationBarItems(leading: addButton)
                .alert("Create Folder", isPresented: $showAlert) {
                    TextField("name", text: $inputName)
                    Button("Save", role: .destructive) {
                        withAnimation(Animation.easeInOut(duration: 0.2)) {
                            views.insert(inputName, at: 0)
                        }
                    }
                    Button("Cancel", role: .cancel) {
                        print("Cancel Tapped")
                    }
                }
            }
        }
    }
    
    var addButton: some View {
        Button(action: {
            inputName = currentDateTime()
            showAlert = true
        }) {
            Image(systemName: "plus")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
