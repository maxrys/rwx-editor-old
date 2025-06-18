
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
                .background(
                    FIFinderSyncController.isExtensionEnabled ? Color.green : Color.red )
                .cornerRadius(5)

            Button {
                FinderSync.FIFinderSyncController.showExtensionManagementInterface()
            } label: {
                Text("Open Settings")
            }

        }
        .padding(20)
    }

}

#Preview {
    MainView()
}
