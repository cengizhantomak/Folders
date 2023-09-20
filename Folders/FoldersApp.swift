//
//  FoldersApp.swift
//  Folders
//
//  Created by Cengizhan Tomak on 4.09.2023.
//

import SwiftUI

@main
struct FoldersApp: App {
    
    init() {
        setupNavigationBarAppearance()
    }
    
    var body: some Scene {
        WindowGroup {
            FolderView()
        }
    }
    
    private func setupNavigationBarAppearance() {
        UINavigationBar.appearance().setBackgroundImage(UIImage(), for: .default)
        UINavigationBar.appearance().shadowImage = UIImage()
        UINavigationBar.appearance().backgroundColor = UIColor.clear
        UINavigationBar.appearance().tintColor = .clear
        UINavigationBar.appearance().isTranslucent = true
    }
}
