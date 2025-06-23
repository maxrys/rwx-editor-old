
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync

struct MainView: View {

    @State var extensionIsEnabled: Bool = false

    var body: some View {
        VStack(spacing: 10) {

            if (self.extensionIsEnabled) {

                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 40, weight: .regular))
                    .foregroundPolyfill(Color.getCustom(.darkGreen))

                Text(NSLocalizedString("extension is enabled", comment: ""))
                    .font(.system(size: 14, weight: .regular))

            } else {

                Image(systemName: "xmark.circle.fill")
                    .font(.system(size: 40, weight: .regular))
                    .foregroundPolyfill(Color.getCustom(.darkRed))

                Text(NSLocalizedString("extension is disabled", comment: ""))
                    .font(.system(size: 14, weight: .regular))

            }

            ButtonCustom(NSLocalizedString("Open Settings", comment: ""), flexibility: .size(200)) {
                FinderSync.FIFinderSyncController.showExtensionManagementInterface()
            }.padding(.top, 10)

        }
        .padding(20)
        .foregroundPolyfill(Color.getCustom(.text))
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            self.extensionIsEnabled = FIFinderSyncController.isExtensionEnabled
        }
    }

}

#Preview {
    MainView()
}
