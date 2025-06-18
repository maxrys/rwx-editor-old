
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct PopupApp: App {

    @Environment(\.openURL) private var openURL

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    private let publisherForFinder = EventsDispatcherGlobal.shared.publisher(
        FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
    )!

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
                .onOpenURL { url in
                    dump(url)
                }
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        PopupMainView(
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
        EventsDispatcherGlobal.shared.on(
            FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU,
            handler: self.onFinderContextMenu
        )
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
    }

    func onFinderContextMenu(event: String) {
        do {
            for path in try FinderEvent.decode(event).paths {
                if let url = URL(string: "rwxEditor://\(path)") {
                    Task {
                        openURL(url)
                    }
                }
            }
        } catch {
            #if DEBUG
                print("decode error \(error)")
            #endif
        }
    }

    func onApply(rights: UInt, owner: String, group: String) {
        print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    PopupApp().mainScene
}
