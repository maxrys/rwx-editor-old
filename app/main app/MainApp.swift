
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct MainApp: App {

    @Environment(\.openURL) private var openURL

    private let publisherForFinder = EventsDispatcherGlobal.shared.publisher(
        FinderSyncExt.EVENT_NAME_FOR_FINDER_CONTEXT_MENU
    )!

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        MainView()
            .environment(
                \.layoutDirection, .leftToRight
            )
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

}

#Preview {
    MainApp().mainScene
}
