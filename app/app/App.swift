
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct ThisApp: App {

    var body: some Scene {
        WindowGroup {
            self.mainScene
        }
    }

    @ViewBuilder var mainScene: some View {
        EditorView(
            rights: 0o644,
            onApplyRights: self.onApplyRights
        )
    }

    func onApplyRights(rights: UInt) {
        print("rights: \(String(rights, radix: 8))")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    ThisApp().mainScene
}
