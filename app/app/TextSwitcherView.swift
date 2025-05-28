
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TextSwitcherView: View {

    static let COLORNAME_SWITCHER_TEXT       = "color TextSwitcher Text"
    static let COLORNAME_SWITCHER_BACKGROUND = "color TextSwitcher Background"

    private var rights: Binding<UInt>

    init(_ rights: Binding<UInt>) {
        self.rights = rights
    }

    var body: some View {
        let isOn: (UInt) -> Bool = { bitPosition in
            self.rights.wrappedValue.bitGet(
                position: bitPosition
            ) == 1
        }
        let text = String(
            "\(isOn(8) ? "r" : "-")\(isOn(7) ? "w" : "-")\(isOn(6) ? "x" : "-")" +
            "\(isOn(5) ? "r" : "-")\(isOn(4) ? "w" : "-")\(isOn(3) ? "x" : "-")" +
            "\(isOn(2) ? "r" : "-")\(isOn(1) ? "w" : "-")\(isOn(0) ? "x" : "-")"
        )
        let textView = {
            Text("\(text)")
                .padding(.horizontal, 9)
                .padding(.top, 3)
                .padding(.bottom, 4)
                .font(.system(size: 13, weight: .regular, design: .monospaced))
                .color(Color(Self.COLORNAME_SWITCHER_TEXT))
                .background(Color(Self.COLORNAME_SWITCHER_BACKGROUND))
                .cornerRadius(5)
        }()
        if #available(macOS 12.0, *) { textView.textSelection(.enabled) }
        else                         { textView }
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        TextSwitcherView($rights)
    }.padding(20)
}
