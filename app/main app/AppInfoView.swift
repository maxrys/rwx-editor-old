
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppInfoView: View {

    static var appVersion      : String { if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { return version } else { return "?" } }
    static var appBundleVersion: String { if let version = Bundle.main.infoDictionary?["CFBundleVersion"           ] as? String { return version } else { return "?" } }
    static var appCopyright    : String { if let version = Bundle.main.infoDictionary?["NSHumanReadableCopyright"  ] as? String { return version } else { return "?" } }

    @Environment(\.colorScheme) private var colorScheme

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
        VStack(spacing: 0) {
            self.shadow
            HStack(spacing: 10) {

                Text(String(format: NSLocalizedString("Version: %@ | Build: %@", comment: ""),
                    Self.appVersion,
                    Self.appBundleVersion
                )).font(.system(size: 13))

                Spacer()

                Text(
                    Self.appCopyright
                ).font(.system(size: 11))

            }.padding(.init(top: 10, leading: 15, bottom: 15, trailing: 15))
        }
        .frame(maxWidth: .infinity)
        .foregroundPolyfill(.gray)
        .background(
            self.colorScheme == .dark ?
            Color.white.opacity(0.03) :
            Color.black.opacity(0.06)
        )
    }
}

#Preview {
    AppInfoView()
        .frame(maxWidth: 600)
}
