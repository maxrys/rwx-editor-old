
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct WindowInfo: Identifiable {
    var id: String = ""
}

@main struct MainApp: App {

    static var owners = Process.systemUsers ().filter{ $0.first != "_" }.sorted()
    static var groups = Process.systemGroups().filter{ $0.first != "_" }.sorted()

    @Environment(\.openWindow) private var openWindow

    var body: some Scene {
        WindowGroup("Rwx Editor", for: WindowInfo.ID.self) { $windowId in
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
                    guard let event = notification.object as? String else { return }
                    for path in try FinderEvent.decode(event).paths {
                        openWindow(value: path)
                    }
                } catch {
                    #if DEBUG
                        print("decode error \(error)")
                    #endif
                }
            }
    }

}

#Preview {
    MainApp().mainScene
}
