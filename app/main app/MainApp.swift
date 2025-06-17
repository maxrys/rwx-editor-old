
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct MainApp: App {

    private let publisherForFinder = EventsDispatcherGlobal.shared.publisher(
        FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
    )!

    var body: some Scene {
        WindowGroup {
            MainView()
        }
    }

    init() {
        EventsDispatcherGlobal.shared.on(
            FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU,
            handler: self.onFinderContextMenu
        )
    }

    func onFinderContextMenu(event: String) {
        dump(
            FinderEvent.decode(event)
        )
    }

}
