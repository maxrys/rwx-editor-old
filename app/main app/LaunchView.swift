
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI
import ServiceManagement

struct LaunchView: View {

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

    @State var isOn: Bool = false

    var body: some View {
        VStack(spacing: 0) {
            ToggleCustom(
                text: NSLocalizedString("Launch at login", comment: ""),
                isOn: self.$isOn
            ).onChange(of: self.isOn) { value in
                Self.launchAtLogin = value
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification))
             { _ in self.isOn = Self.launchAtLogin }
        .onAppear { self.isOn = Self.launchAtLogin }
    }

}

#Preview {
    LaunchView()
        .padding(20)
        .frame(width: 300)
}
