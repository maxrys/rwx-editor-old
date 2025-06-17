
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct ThisApp: App {

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        MainView(
            kind: .file,
            name: "Rwx Editor.icns",
            path: "/usr/local/bin/some/long/path",
            size: 1_234_567,
            created: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
            updated: try! Date(fromISO8601: "2025-01-02 03:04:05 +0000"),
            rights: 0o644,
            owner: "nobody",
            group: "staff",
            onApply: self.onApply
        )
    }

    init() {
        let owners = Process.systemUsers ().filter{ $0.first != "_" }.sorted()
        let groups = Process.systemGroups().filter{ $0.first != "_" }.sorted()
        if (Self.owners.isEmpty) {
            for value in owners {
                Self.owners[value] = value
            }
        }
        if (Self.groups.isEmpty) {
            for value in groups {
                Self.groups[value] = value
            }
        }
        EventsDispatcher.shared.on(FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU) { event in
            if (event.name == "forDirs") {
                print("message: \(event.encode())")
            }
        }
    }

    func onApply(rights: UInt, owner: String, group: String) {
        print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    ThisApp().mainScene
}
