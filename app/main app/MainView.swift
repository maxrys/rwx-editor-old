
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync
import ServiceManagement

struct MainView: View {

    static var launchAtLogin: Bool {
        get { SMAppService.mainApp.status == .enabled }
        set(isEnabled) {
            do {
                if (isEnabled) { try SMAppService.mainApp.register  () }
                else           { try SMAppService.mainApp.unregister() }
            } catch {}
        }
    }

    @Environment(\.colorScheme) private var colorScheme
    @State var extensionIsEnabled: Bool = false
    @State var launchAtLoginIsOn: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 10) {
                if (self.extensionIsEnabled) {

                    Image(systemName: "checkmark.circle.fill")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundPolyfill(Color.getCustom(.darkGreen))
                        .background(Color.white)
                        .clipShape(Circle())

                    Text(NSLocalizedString("extension is enabled", comment: ""))
                        .font(.system(size: 14, weight: .regular))

                } else {

                    Image(systemName: "xmark.circle.fill")
                        .frame(width: 40, height: 40)
                        .font(.system(size: 40, weight: .bold))
                        .foregroundPolyfill(Color.getCustom(.darkRed))
                        .background(Color.white)
                        .clipShape(Circle())

                    Text(NSLocalizedString("extension is disabled", comment: ""))
                        .font(.system(size: 14, weight: .regular))

                }
            }
            .padding(20)
            .frame(maxWidth: .infinity)
            .background(
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
                    .cornerRadius(15)
            )

            ButtonCustom(NSLocalizedString("Open Settings", comment: ""), flexibility: .size(230)) {
                FinderSync.FIFinderSyncController.showExtensionManagementInterface()
            }

            ToggleCustom(
                text: "Launch at login",
                isOn: self.$launchAtLoginIsOn
            )

        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
                     self.extensionIsEnabled = FIFinderSyncController.isExtensionEnabled
        }.onAppear { self.extensionIsEnabled = FIFinderSyncController.isExtensionEnabled }
        .padding(20)
        .foregroundPolyfill(Color.getCustom(.text))
        .frame(width: 300)
    }

}

#Preview {
    MainView()
}
