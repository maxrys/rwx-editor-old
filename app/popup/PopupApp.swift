
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct PopupApp: App {

    @Environment(\.scenePhase) var scenePhase

    static let FRAME_WIDTH: CGFloat = 300
    static let URL_PREFIX = "rwxEditor://"
    static let NA_SIGN = "—"

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    @State private var fsEntityInfo = FSEntityInfo("")
    @State private var rights: UInt = 0
    @State private var owner: String = ""
    @State private var group: String = ""

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
                .onOpenURL { url in
                     let absolute = url.absoluteString
                     if (absolute.isEmpty == false) {
                         if (absolute[0, UInt(Self.URL_PREFIX.count-1)] == Self.URL_PREFIX) {
                             let incommingUrl = String(
                                 absolute[
                                     UInt(Self.URL_PREFIX.count),
                                     UInt(absolute.count-1)
                                 ]
                             )
                             self.fsEntityInfo = FSEntityInfo(incommingUrl)
                             self.rights = self.fsEntityInfo.rights
                             self.owner  = self.fsEntityInfo.owner
                             self.group  = self.fsEntityInfo.group
                         }
                     }
                }
        }.onChange(of: scenePhase) { phase in
            if (phase == .background) {
                NSApplication.shared.terminate(nil)
            }
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        VStack(spacing: 0) {
            PopupMainView(
                rights : self.$rights,
                owner  : self.$owner,
                group  : self.$group,
                info   : self.fsEntityInfo,
                onApply: self.onApply
            )
        }.frame(width: PopupApp.FRAME_WIDTH)
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
