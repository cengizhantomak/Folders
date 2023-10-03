//
//  CustomSearchBar.swift
//  Folders
//
//  Created by Kerem Tuna Tomak on 3.10.2023.
//

import SwiftUI

struct CustomSearchBar: View {
    var Placeholder: String
    @Binding var Text: String
    
    var body: some View {
        HStack {
            Image(systemName: StringConstants.SystemImage.Magnifyingglass)
                .foregroundColor(.gray)
            
            TextField(Placeholder, text: $Text)
                .foregroundColor(.gray)
            
            if !Text.isEmpty {
                Button(action: {
                    self.Text = String()
                }) {
                    Image(systemName: StringConstants.SystemImage.MultiplyCircleFill)
                        .foregroundColor(.gray)
                }
            }
        }
        .padding(7)
        .background(Color(.systemGray5))
        .cornerRadius(8)
    }
}

#Preview {
    CustomSearchBar(Placeholder: "Search...", Text: .constant("LVS"))
}
