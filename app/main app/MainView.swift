
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

                let icon  = self.extensionIsEnabled ? "checkmark.circle.fill" : "xmark.circle.fill"
                let color = self.extensionIsEnabled ? Color.getCustom(.darkGreen) : Color.getCustom(.darkRed)
                let text  = self.extensionIsEnabled ? "extension is enabled" : "extension is disabled"

                Image(systemName: icon)
                    .frame(width: 40, height: 40)
                    .font(.system(size: 40, weight: .bold))
                    .foregroundPolyfill(color)
                    .background(Color.white)
                    .clipShape(Circle())

                Text(NSLocalizedString(text, comment: ""))
                    .font(.system(size: 14, weight: .regular))

                ButtonCustom(NSLocalizedString("Open Settings", comment: ""),
                             textColor: Color(ButtonCustom.ColorNames.text.rawValue),
                             backgroundColor: Color(ButtonCustom.ColorNames.background.rawValue),
                             flexibility: .infinity) {
                    FinderSync.FIFinderSyncController.showExtensionManagementInterface()
                }.padding(.top, 10)

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

            ToggleCustom(
                text: NSLocalizedString("Launch at login", comment: ""),
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
