
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct TextSwitcherView: View {

    enum Colors: String {
        case text       = "color TextSwitcher Text"
        case background = "color TextSwitcher Background"
    }

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
            "\( self.isOn(rightsValue, Subject.owner.offset + Permission.r.offset) ? symbolR : symbolE )\( self.isOn(rightsValue, Subject.owner.offset + Permission.w.offset) ? symbolW : symbolE )\( self.isOn(rightsValue, Subject.owner.offset + Permission.x.offset) ? symbolX : symbolE )" +
            "\( self.isOn(rightsValue, Subject.group.offset + Permission.r.offset) ? symbolR : symbolE )\( self.isOn(rightsValue, Subject.group.offset + Permission.w.offset) ? symbolW : symbolE )\( self.isOn(rightsValue, Subject.group.offset + Permission.x.offset) ? symbolX : symbolE )" +
            "\( self.isOn(rightsValue, Subject.other.offset + Permission.r.offset) ? symbolR : symbolE )\( self.isOn(rightsValue, Subject.other.offset + Permission.w.offset) ? symbolW : symbolE )\( self.isOn(rightsValue, Subject.other.offset + Permission.x.offset) ? symbolX : symbolE )"
        )
        let textView = {
            Text(text)
                .padding(.horizontal, 9)
                .padding(.top, 4)
                .padding(.bottom, 6)
                .font(.system(size: 13, weight: .regular, design: .monospaced))
                .color(Color(Self.Colors.text.rawValue))
                .background(Color(Self.Colors.background.rawValue))
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
