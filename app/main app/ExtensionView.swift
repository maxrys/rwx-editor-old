
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync

struct ExtensionView: View {

    @State var isOn: Bool = false

    var body: some View {
        VStack(spacing: 10) {

            let icon = self.isOn ? "checkmark.circle.fill" : "xmark.circle.fill"
            let text = self.isOn ? "extension is enabled" : "extension is disabled"

            let color = Color.getCustom(
                self.isOn ? .darkGreen : .darkRed
            )

            Image(systemName: icon)
                .frame(width: 40, height: 40)
                .font(.system(size: 40, weight: .bold))
                .foregroundPolyfill(color)
                .background(Color.white)
                .clipShape(Circle())

            Text(NSLocalizedString(text, comment: ""))
                .font(.system(size: 14, weight: .regular))

            ButtonCustom(NSLocalizedString("Open Settings", comment: ""), style: .custom, flexibility: .infinity) {
                FinderSync.FIFinderSyncController.showExtensionManagementInterface()
            }.padding(.top, 10)

        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
             { _ in self.isOn = FIFinderSyncController.isExtensionEnabled }
        .onAppear { self.isOn = FIFinderSyncController.isExtensionEnabled }
    }

}

#Preview {
    ExtensionView()
        .padding(20)
        .frame(width: 200)
}
