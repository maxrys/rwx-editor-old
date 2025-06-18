
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync

struct MainView: View {

    var body: some View {
        VStack(spacing: 20) {

            let title: String = {
                if (FIFinderSyncController.isExtensionEnabled)
                     { return NSLocalizedString("extension is enabled" , comment: "") }
                else { return NSLocalizedString("extension is disabled", comment: "") }
            }()

            Text(title)
                .font(.system(size: 12, weight: .regular))
                .foregroundPolyfill(.white)
                .padding(20)
                .frame(maxWidth: .infinity)
                .background(
                    FIFinderSyncController.isExtensionEnabled ?
                        Color.getCustom(.softGreen) :
                        Color.getCustom(.softRed)
                ).cornerRadius(5)

            ButtonCustom(NSLocalizedString("Open Settings", comment: ""), flexibility: .size(200)) {
                FinderSync.FIFinderSyncController.showExtensionManagementInterface()

            }

        }
        .padding(20)
        .foregroundPolyfill(Color.getCustom(.text))
    }

}

#Preview {
    MainView()
}
