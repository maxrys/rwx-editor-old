
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct RwxTextView: View {

    enum ColorNames: String {
        case text       = "color RwxTextView Text"
        case background = "color RwxTextView Background"
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
        Text(text)
            .padding(.horizontal, 9)
            .padding(.top, 4)
            .padding(.bottom, 6)
            .font(.system(size: 13, weight: .regular, design: .monospaced))
            .color(Color(Self.ColorNames.text.rawValue))
            .background(Color(Self.ColorNames.background.rawValue))
            .cornerRadius(5)
            .textSelectionEnable()
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    HStack {
        RwxTextView($rights)
    }.padding(20)
}
