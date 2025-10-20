
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync

struct ExtensionView: View {

    @Environment(\.colorScheme) private var colorScheme
    @State private var isOn: Bool

    init() {
        self.isOn = false
    }

    @ViewBuilder var groupBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(
                self.colorScheme == .dark ?
                    Color.white.opacity(0.5) :
                    Color.black.opacity(0.5),
                lineWidth: 1
            )
            .background(
                self.colorScheme == .dark ?
                    Color.black.opacity(0.2) :
                    Color.white.opacity(0.7)
            )
    }

    var body: some View {
        VStack(spacing: 10) {

            let icon = self.isOn ? "checkmark.circle.fill" : "xmark.circle.fill"
            let text = self.isOn ? "extension is enabled" : "extension is disabled"

            let color = self.isOn ?
                Color.custom.darkGreen :
                Color.custom.darkRed

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
        .padding(20)
        .frame(maxWidth: .infinity)
        .background(self.groupBackground)
        .clipShape(RoundedRectangle(cornerRadius: 15))
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
             { _ in self.isOn = FIFinderSyncController.isExtensionEnabled }
        .onAppear { self.isOn = FIFinderSyncController.isExtensionEnabled }
    }

}

#Preview {
    ExtensionView()
        .padding(20)
        .frame(width: 300)
}
