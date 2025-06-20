
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

    private let publisherForFinder = EventsDispatcherGlobal.shared.publisher(
        FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
    )!

    var body: some Scene {
        WindowGroup(for: WindowInfo.ID.self) { $windowId in
            if let windowId {
                /* MARK: Popup windows */
                PopupView(
                    windowId: windowId
                )
            } else {
                /* MARK: Parent Window */
                self.mainScene
            }
        }.windowResizability(.contentSize)
    }

    @ViewBuilder var mainScene: some View {
        MainView()
            .environment(\.layoutDirection, .leftToRight)
    }

    init() {
        EventsDispatcherGlobal.shared.on(
            FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU,
            handler: self.onFinderContextMenu
        )
    }

    func onFinderContextMenu(event: String) {
        do {
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

#Preview {
    MainApp().mainScene
}
