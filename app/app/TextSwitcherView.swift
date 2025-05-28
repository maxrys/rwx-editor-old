
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

    let isOn: (UInt, UInt) -> Bool = { rightsValue, bitPosition in
        rightsValue.bitGet(
            position: bitPosition
        ) == 1
    }

    var body: some View {
        let rightsValue = self.rights.wrappedValue
        let symbolR = Permission.r.rawValue
        let symbolW = Permission.w.rawValue
        let symbolX = Permission.x.rawValue
        let symbolE = "-"
        let text = String(
            "\( self.isOn(rightsValue, 8) ? symbolR : symbolE )\( self.isOn(rightsValue, 7) ? symbolW : symbolE )\( self.isOn(rightsValue, 6) ? symbolX : symbolE )" +
            "\( self.isOn(rightsValue, 5) ? symbolR : symbolE )\( self.isOn(rightsValue, 4) ? symbolW : symbolE )\( self.isOn(rightsValue, 3) ? symbolX : symbolE )" +
            "\( self.isOn(rightsValue, 2) ? symbolR : symbolE )\( self.isOn(rightsValue, 1) ? symbolW : symbolE )\( self.isOn(rightsValue, 0) ? symbolX : symbolE )"
        )
        let textView = {
            Text(text)
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
