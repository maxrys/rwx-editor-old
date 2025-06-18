
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

@main struct MainApp: App {

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    init() {
    }

    @ViewBuilder var mainScene: some View {
        MainView()
            .environment(
                \.layoutDirection, .leftToRight
            )
    }

}

#Preview {
    MainApp().mainScene
}
