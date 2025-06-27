
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import FinderSync
import ServiceManagement

struct MainView: View {

    static let FRAME_WIDTH: CGFloat = 300

    static var launchAtLogin: Bool {
        get {
            if #available(macOS 13.0, *)
                 { return SMAppService.mainApp.status == .enabled }
            else { return false }
        }
        set(isEnabled) {
            do {
                if #available(macOS 13.0, *) {
                    if (isEnabled) { try SMAppService.mainApp.register  () }
                    else           { try SMAppService.mainApp.unregister() }
                }
            } catch {}
        }
    }

    @Environment(\.colorScheme) private var colorScheme
    @State var isEnabledExtension: Bool = false
    @State var isEnabledLaunchAtLogin: Bool = false

    var body: some View {
        VStack(spacing: 20) {

            VStack(spacing: 10) {

                let icon  = self.isEnabledExtension ? "checkmark.circle.fill" : "xmark.circle.fill"
                let color = self.isEnabledExtension ? Color.getCustom(.darkGreen) : Color.getCustom(.darkRed)
                let text  = self.isEnabledExtension ? "extension is enabled" : "extension is disabled"

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

            if #available(macOS 13.0, *) {
                ToggleCustom(
                    text: NSLocalizedString("Launch at login", comment: ""),
                    isOn: self.$isEnabledLaunchAtLogin
                ).onChange(of: self.isEnabledLaunchAtLogin) { value in
                    Self.launchAtLogin = value
                }
            }

        }
        .padding(20)
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
             { _ in self.updateView() }
        .onAppear { self.updateView() }
    }

    func updateView() {
        self.isEnabledExtension = FIFinderSyncController.isExtensionEnabled
        self.isEnabledLaunchAtLogin = Self.launchAtLogin
    }

}

#Preview {
    MainView()
}
