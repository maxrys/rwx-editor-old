
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct MainView: View {

    static let FRAME_WIDTH: CGFloat = 300

    @Environment(\.colorScheme) private var colorScheme

    @ViewBuilder var groupBackground: some View {
        RoundedRectangle(cornerRadius: 15)
            .stroke(
                self.colorScheme == .dark ?
                    Color.white.opacity(0.5) :
                    Color.black.opacity(0.5),
                lineWidth: 1
            )
            .background(
                self.colorScheme == .dark ?
                    Color.black.opacity(0.2) :
                    Color.white.opacity(0.7)
            )
    }

    @ViewBuilder var shadow: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.black.opacity(self.colorScheme == .light ? 0.1 : 0.4),
                        Color.clear ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            ).frame(height: 6)
    }

    var body: some View {
        VStack(spacing: 10) {

            VStack(spacing: 20) {

                /* MARK: extension status */
                ExtensionView()
                    .padding(20)
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background(self.groupBackground)

                /* MARK: scopes */
                ScopesView()
                    .frame(maxWidth: .infinity)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .background(self.groupBackground)

                /* MARK: launch at login */
                if #available(macOS 13.0, *) {
                    LaunchView()
                }

            }.padding(15)

            /* MARK: version, build, copyright */
            VStack(spacing: 0) {

                /* shadow */
                self.shadow

                /* version + build + copyright */
                AppInfoView()

            }.background(
                self.colorScheme == .dark ?
                Color.white.opacity(0.03) :
                Color.black.opacity(0.06)
            )

        }
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
    }

}

#Preview {
    MainView()
}
