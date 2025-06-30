
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct DebugInfoView: View {

    static let NA_SIGN = "—"

    private var info: Binding<FSEntityInfo>

    init(_ info: Binding<FSEntityInfo>) {
        self.info = info
    }

    var body: some View {
        VStack(spacing: 0) {
            let debugInfo: [String] = [
                String(format: "%@: %@", "url"   , String(self.info.wrappedValue.initUrl)),
                String(format: "%@: %@", "rights", String(self.info.wrappedValue.rights)),
                String(format: "%@: %@", "owner" , self.info.wrappedValue.owner.isEmpty ? Self.NA_SIGN : self.info.wrappedValue.owner),
                String(format: "%@: %@", "group" , self.info.wrappedValue.group.isEmpty ? Self.NA_SIGN : self.info.wrappedValue.group),
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

@available(macOS 14.0, *) #Preview {
    @Previewable @State var info = FSEntityInfo("/private/etc/")
    DebugInfoView(
        $info
    ).frame(width: 200)
}
