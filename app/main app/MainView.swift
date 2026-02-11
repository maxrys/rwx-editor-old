
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainView: View {

    static let FRAME_WIDTH : CGFloat = 700
    static let FRAME_HEIGHT: CGFloat = 400

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {

                VStack(spacing: 20) {

                    /* MARK: extension status */
                    ExtensionView()
                        .padding(.top, 30)

                    /* MARK: launch at login */
                    if #available(macOS 13.0, *) {
                        LaunchView()
                    }

                }
                .padding(15)
                .frame(maxWidth: 300, maxHeight: .infinity, alignment: .top)

                /* MARK: bookmarks */
                BookmarksView()

            }

            /* MARK: version, build, copyright */
            AppInfoView()

        }
        .foregroundPolyfill(Color.custom.text)
        .frame(width: Self.FRAME_WIDTH, height: Self.FRAME_HEIGHT)
    }

}

#Preview {
    MainView()
}
