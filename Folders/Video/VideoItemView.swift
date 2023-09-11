//
//  VideoItemView.swift
//  Folders
//
//  Created by Cengizhan Tomak on 11.09.2023.
//

import SwiftUI

struct VideoItemView: View {
    var Video: VideoModel
    let ItemWidth: CGFloat
    
    var body: some View {
        ZStack {
            Rectangle()
                .fill(Color.gray.opacity(0.15))
                .frame(width: ItemWidth, height: ItemWidth * 16/9)
                .cornerRadius(2)
            Image(systemName: "play")
                .resizable()
                .scaledToFit()
                .frame(width: ItemWidth * 0.3, height: ItemWidth * 0.3)
                .foregroundColor(Color.gray)
            VStack(alignment: .leading) {
                Spacer()
                Text(Video.Name)
                    .font(.system(size: 7))
                    .padding(10)
            }
        }
    }
}

struct VideoItemView_Previews: PreviewProvider {
    static var previews: some View {
        VideoItemView(Video: VideoModel(), ItemWidth: 100)
    }
}
