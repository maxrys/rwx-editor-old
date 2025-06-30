
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DebugInfoView: View {

    static let NA_SIGN = "—"

    private var info: FSEntityInfo

    init(_ info: FSEntityInfo) {
        self.info = info
    }

    var body: some View {
        VStack(spacing: 0) {
            let debugInfo: [String] = [
                String(format: "%@: %@", "url"   , String(self.info.initUrl)),
                String(format: "%@: %@", "rights", String(self.info.rights)),
                String(format: "%@: %@", "owner" , self.info.owner.isEmpty ? Self.NA_SIGN : self.info.owner),
                String(format: "%@: %@", "group" , self.info.group.isEmpty ? Self.NA_SIGN : self.info.group),
            ]
            Text("DEBUG INFO\n\(debugInfo.joined(separator: "\n"))")
                .fixedSize(horizontal: false, vertical: true)
                .padding(10)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .foregroundPolyfill(Color(.white))
        .background(Color.gray)
    }

}

#Preview {
    let info = FSEntityInfo("/private/etc/")
    DebugInfoView(info)
        .frame(width: 200)
}
