//
//  CustomTTProgressHUD.swift
//  Folders
//
//  Created by Cengizhan Tomak on 20.09.2023.
//

import SwiftUI
import TTProgressHUD

struct CustomTTProgressHUD: View {
    @Binding var IsSuccessVisible: Bool
    @Binding var IsErrorVisible: Bool

    private let HudConfigSuccess = TTProgressHUDConfig(type: .success ,shouldAutoHide: true, autoHideInterval: 0.5)
    private let HudConfigError = TTProgressHUDConfig(type: .error, shouldAutoHide: true, autoHideInterval: 0.5)

    var body: some View {
        Group {
            TTProgressHUD($IsSuccessVisible, config: HudConfigSuccess)
                .scaleEffect(0.5)
            TTProgressHUD($IsErrorVisible, config: HudConfigError)
                .scaleEffect(0.5)
        }
    }
}
