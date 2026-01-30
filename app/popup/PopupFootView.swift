
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupFootView: View {

    enum ColorNames: String {
        case foot = "color PopupView Foot Background"
    }

    private var info: Binding<FSEntityInfo>
    private var rights: Binding<UInt>
    private var owner: Binding<String>
    private var group: Binding<String>
    private var onCancel: () -> Void = {}
    private var onApply : () -> Void = {}

    init(_ info: Binding<FSEntityInfo>, _ rights: Binding<UInt>, _ owner: Binding<String>, _ group: Binding<String>, _ onCancel: @escaping () -> Void = {}, _ onApply: @escaping () -> Void = {}) {
        self.info     = info
        self.rights   = rights
        self.owner    = owner
        self.group    = group
        self.onCancel = onCancel
        self.onApply  = onApply
    }

    private var isChanged: Bool {
        self.rights.wrappedValue != self.info.rights.wrappedValue ||
        self.owner .wrappedValue != self.info.owner .wrappedValue ||
        self.group .wrappedValue != self.info.group .wrappedValue
    }

    var body: some View {
        HStack(spacing: 10) {

            /* MARK: cancel button */
            ButtonCustom(NSLocalizedString("cancel", comment: ""), flexibility: .size(100)) {
                self.onCancel()
            }.disabled(
                self.isChanged == false
            )

            /* MARK: apply button */
            ButtonCustom(NSLocalizedString("apply", comment: ""), flexibility: .size(100)) {
                self.onApply()
            }.disabled(
                self.isChanged == false ||
                self.info.type.wrappedValue == .unknown
            )

        }
        .padding(25)
        .frame(maxWidth: .infinity)
        .background(Color(Self.ColorNames.foot.rawValue))
    }

}

@available(macOS 14.0, *) #Preview {
    VStack(spacing: 10) {
        PopupFootView(
            Binding.constant(FSEntityInfo("/private/etc/")),
            Binding.constant(FSEntityInfo("/private/etc/").rights),
            Binding.constant(FSEntityInfo("/private/etc/").owner),
            Binding.constant(FSEntityInfo("/private/etc/").group)
        )
        PopupFootView(
            Binding.constant(FSEntityInfo("/private/etc/")),
            Binding.constant(0o644),
            Binding.constant(""),
            Binding.constant("")
        )
    }
    .padding(10)
    .background(Color.black)
    .frame(width: 320)
}
