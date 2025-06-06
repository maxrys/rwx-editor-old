
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

enum Kind {

    case dirrectory
    case file

}

@main struct ThisApp: App {

    static var owners: [String] = []
    static var groups: [String] = []

    var body: some Scene {
        WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
        }
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
            owner: 0,
            group: 0,
            onApply: self.onApply
        )
    }

    init() {
        if (Self.owners.isEmpty) { Self.owners = Process.systemUsers ().filter{ $0.first != "_" }.sorted() }
        if (Self.groups.isEmpty) { Self.groups = Process.systemGroups().filter{ $0.first != "_" }.sorted() }
    }

    func onApply(rights: UInt, owner: UInt, group: UInt) {
        let ownerValue = Self.owners[Int(owner)]
        let groupValue = Self.groups[Int(group)]
        print("rights: \(String(rights, radix: 8)) | owner: \(ownerValue) | group: \(groupValue)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    ThisApp()
        .mainScene
        .frame(width: 300)
}
