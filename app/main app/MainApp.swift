
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct MainApp: App {

    static var owners = Process.systemUsers ().filter{ $0.first != "_" }.sorted()
    static var groups = Process.systemGroups().filter{ $0.first != "_" }.sorted()

    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("Rwx Editor", for: String.self) { $windowId in
            if let windowId {
                /* MARK: Popup windows */
                PopupView(
                    windowId: windowId
                )
            } else {
                /* MARK: Parent Window */
                self.mainScene
            }
        }
        .environment(\.layoutDirection, .leftToRight)
        .windowResizability(.contentSize)
    }

    @ViewBuilder var mainScene: some View {
        MainView()
            .onReceive(
                DistributedNotificationCenter.default.publisher(
                    for: Notification.Name(FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU)
                )
            ) { notification in
                do {
                    guard let json = notification.object as? String else { return }
                    guard let finderEvent = FinderEvent(from: json) else { return }
                    for path in finderEvent.paths {
                        openWindow(value: path)
                    }
                }
            }
    }

}

#Preview {
    MainApp().mainScene
}
