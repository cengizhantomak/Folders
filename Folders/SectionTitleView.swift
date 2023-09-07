//
//  SectionTitleView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 7.09.2023.
//

import SwiftUI

struct SectionTitleView: View {
    var Title: String
    
    var body: some View {
        VStack(alignment: .leading) {
            Divider()
            Text(Title).font(.headline)
        }
    }
}

struct SectionTitleView_Previews: PreviewProvider {
    static var previews: some View {
        SectionTitleView(Title: "LVS")
    }
}
