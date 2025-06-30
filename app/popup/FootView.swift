
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct FootView: View {

    enum ColorNames: String {
        case foot = "color PopupView Foot Background"
    }

    private var info: FSEntityInfo
    private var rights: Binding<UInt>
    private var owner: Binding<String>
    private var group: Binding<String>
    private var onCancel: () -> Void = {}
    private var onApply : () -> Void = {}

    init(_ info: FSEntityInfo, _ rights: Binding<UInt>, _ owner: Binding<String>, _ group: Binding<String>, _ onCancel: @escaping () -> Void = {}, _ onApply: @escaping () -> Void = {}) {
        self.info     = info
        self.rights   = rights
        self.owner    = owner
        self.group    = group
        self.onCancel = onCancel
        self.onApply  = onApply
    }

    private var isChanged: Bool {
        self.rights.wrappedValue != self.info.rights ||
        self.owner.wrappedValue  != self.info.owner  ||
        self.group.wrappedValue  != self.info.group
    }

    var body: some View {
        HStack(spacing: 10) {

            /* MARK: cancel button */
            ButtonCustom(NSLocalizedString("cancel", comment: ""), flexibility: .size(100)) {
                self.onCancel()
            }.disabled(self.isChanged == false)

            /* MARK: apply button */
            ButtonCustom(NSLocalizedString("apply", comment: ""), flexibility: .size(100)) {
                self.onApply()
            }.disabled(self.isChanged == false || self.info.type == .unknown)

        }
        .padding(25)
        .frame(maxWidth: .infinity)
        .background(Color(Self.ColorNames.foot.rawValue))
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt  = FSEntityInfo("/private/etc/").rights
    @Previewable @State var ovner: String = FSEntityInfo("/private/etc/").owner
    @Previewable @State var group: String = FSEntityInfo("/private/etc/").group
    let info = FSEntityInfo("/private/etc/")
    VStack(spacing: 10) {
        FootView(
            info,
            $rights,
            $ovner,
            $group
        )
    }
    .padding(10)
    .background(Color.black)
    .frame(width: 320)
}
