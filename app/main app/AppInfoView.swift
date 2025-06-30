
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct AppInfoView: View {

    static var appVersion      : String { if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String { return version } else { return "?" } }
    static var appBundleVersion: String { if let version = Bundle.main.infoDictionary?["CFBundleVersion"           ] as? String { return version } else { return "?" } }
    static var appCopyright    : String { if let version = Bundle.main.infoDictionary?["NSHumanReadableCopyright"  ] as? String { return version } else { return "?" } }

    var body: some View {
        VStack(spacing: 10) {

            Text(String(format: NSLocalizedString("Version: %@ | Build: %@", comment: ""),
                Self.appVersion,
                Self.appBundleVersion
            )).font(.system(size: 13))

            Text(
                Self.appCopyright
            ).font(.system(size: 11))

        }
        .padding(.init(top: 10, leading: 15, bottom: 15, trailing: 15))
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
        .foregroundPolyfill(.gray)
    }
}

#Preview {
    AppInfoView()
        .frame(maxWidth: 200)
}
