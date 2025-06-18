
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct EntityInfo {

    var kind: Kind = .unknown
    var name: String = "n/a"
    var path: String = "n/a"
    var size: UInt = 0
    var created: Date = try! Date(fromISO8601: "2025-01-01 00:00:00 +0000")
    var updated: Date = try! Date(fromISO8601: "2025-01-01 00:00:00 +0000")
    var rights: UInt = 0
    var owner: String = ""
    var group: String = ""

}

@main struct PopupApp: App {

    static let FRAME_WIDTH: CGFloat = 300
    static let URL_PREFIX = "rwxEditor://"

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    @State var receivedUrl: String = ""

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
                .onOpenURL { url in
                    let absolute = url.absoluteString
                    if (absolute.isEmpty == false) {
                        if (absolute[0, Self.URL_PREFIX.count-1] == Self.URL_PREFIX) {
                            self.receivedUrl = String(
                                absolute[
                                    Self.URL_PREFIX.count,
                                    absolute.count-1
                                ]
                            )
                        }
                    }
                }
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        VStack(spacing: 0) {
            #if DEBUG
                if (self.receivedUrl.isEmpty)
                     { Text(String(format: NSLocalizedString("url: %@", comment: ""),      "n/a"      )).padding(10).frame(maxWidth: .infinity).foregroundPolyfill(Color(.white)).background(Color.getCustom(.softRed  )) }
                else { Text(String(format: NSLocalizedString("url: %@", comment: ""), self.receivedUrl)).padding(10).frame(maxWidth: .infinity).foregroundPolyfill(Color(.white)).background(Color.getCustom(.softGreen)) }
            #endif
            PopupMainView(
                info: self.parseURL(url: self.receivedUrl),
                onApply: self.onApply
            )
        }.frame(width: PopupApp.FRAME_WIDTH)
    }

    func parseURL(url: String) -> EntityInfo {
        var result = EntityInfo()
        if (url != "") {
            result.kind = url.last == "/" ? .dirrectory : .file
            result.name = URL(string: url)!.lastPathComponent
            result.path = url
            result.size = 1_234_567
            result.created = try! Date(fromISO8601: "2025-01-02 03:04:05 +0000")
            result.updated = try! Date(fromISO8601: "2025-01-02 03:04:05 +0000")
            result.rights = 0o644
            result.owner = "nobody"
            result.group = "staff"
        }
        return result
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
    }

    func onApply(rights: UInt, owner: String, group: String) {
        print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    PopupApp().mainScene
}
