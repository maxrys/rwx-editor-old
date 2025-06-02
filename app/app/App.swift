
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

enum Permission: String {

    case r = "r"
    case w = "w"
    case x = "x"

    var offset: UInt {
        switch self {
            case .r: return 2
            case .w: return 1
            case .x: return 0
        }
    }

}

enum Subject {

    case owner
    case group
    case other

    var offset: UInt {
        switch self {
            case .owner: return 6
            case .group: return 3
            case .other: return 0
        }
    }

}

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
    ThisApp()
        .mainScene
        .frame(width: 300, height: 350)
}
