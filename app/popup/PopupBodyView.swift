
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupBodyView: View {

    var owners: [String: String] = {
        var result: [String: String] = [:]
        Process.systemUsers().filter({ $0.first != "_" }).sorted().forEach { value in
            result[value] = value
        }
        return result
    }()

    var groups: [String: String] = {
        var result: [String: String] = [:]
        Process.systemGroups().filter({ $0.first != "_" }).sorted().forEach { value in
            result[value] = value
        }
        return result
    }()

    @Environment(\.colorScheme) private var colorScheme

    private var info: Binding<FSEntityInfo>
    private var rights: Binding<UInt>
    private var owner: Binding<String>
    private var group: Binding<String>

    init(_ info: Binding<FSEntityInfo>, _ rights: Binding<UInt>, _ owner: Binding<String>, _ group: Binding<String>) {
        self.info   = info
        self.rights = rights
        self.owner  = owner
        self.group  = group
    }

    @ViewBuilder var shadowTop: some View {
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

    @ViewBuilder var shadowBottom: some View {
        Rectangle()
            .fill(
                LinearGradient(
                    colors: [
                        Color.clear,
                        Color.black.opacity(self.colorScheme == .light ? 0.1 : 0.4) ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .frame(height: 6)
            .padding(.top, 6)
    }

    var body: some View {
        VStack(spacing: 20) {

            self.shadowTop

            /* MARK: rules via toggles */
            HStack(spacing: 0) {

                let textW: CGFloat = 60
                let textH: CGFloat = 25

                VStack(spacing: 10) {
                    Color.clear.frame(width: textW, height: textH)
                    Text(NSLocalizedString("Owner", comment: "")).frame(width: textW, height: textH)
                    Text(NSLocalizedString("Group", comment: "")).frame(width: textW, height: textH)
                    Text(NSLocalizedString("Other", comment: "")).frame(width: textW, height: textH)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Read", comment: "")).frame(width: textW, height: textH)
                    ToggleRwxColored(.owner, self.rights, bitPosition: Subject.owner.offset + Permission.r.offset)
                    ToggleRwxColored(.group, self.rights, bitPosition: Subject.group.offset + Permission.r.offset)
                    ToggleRwxColored(.other, self.rights, bitPosition: Subject.other.offset + Permission.r.offset)
                }

                VStack(spacing: 10) {
                    Text(NSLocalizedString("Write", comment: "")).frame(width: textW, height: textH)
                    ToggleRwxColored(.owner, self.rights, bitPosition: Subject.owner.offset + Permission.w.offset)
                    ToggleRwxColored(.group, self.rights, bitPosition: Subject.group.offset + Permission.w.offset)
                    ToggleRwxColored(.other, self.rights, bitPosition: Subject.other.offset + Permission.w.offset)
                }

                VStack(spacing: 10) {
                    let text = self.info.type.wrappedValue == .file ? "Execute" : "Access"
                    Text(NSLocalizedString(text, comment: "")).frame(width: textW, height: textH)
                    ToggleRwxColored(.owner, self.rights, bitPosition: Subject.owner.offset + Permission.x.offset);
                    ToggleRwxColored(.group, self.rights, bitPosition: Subject.group.offset + Permission.x.offset);
                    ToggleRwxColored(.other, self.rights, bitPosition: Subject.other.offset + Permission.x.offset);
                }

            }

            /* MARK: rules via text/numeric */
            HStack(spacing: 20) {
                RwxTextView(self.rights)
                ToggleRwxNumeric(self.rights)
            }

            VStack(alignment: .trailing, spacing: 10) {

                /* MARK: owner picker */
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Owner", comment: ""))
                    PickerCustom<String>(
                        selected: self.owner,
                        values: self.owners,
                        isPlainListStyle: true,
                        flexibility: .size(150)
                    )
                }

                /* MARK: group picker */
                HStack(spacing: 10) {
                    Text(NSLocalizedString("Group", comment: ""))
                    PickerCustom<String>(
                        selected: self.group,
                        values: self.groups,
                        isPlainListStyle: true,
                        flexibility: .size(150)
                    )
                }

            }.padding(.top, 10)

            self.shadowBottom

        }
        .frame(maxWidth: .infinity)
        
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var info: FSEntityInfo = FSEntityInfo("/private/etc/")
    @Previewable @State var rights: UInt       = FSEntityInfo("/private/etc/").rights
    @Previewable @State var owner: String      = FSEntityInfo("/private/etc/").owner
    @Previewable @State var group: String      = FSEntityInfo("/private/etc/").group
    VStack {
        DebugInfoView($info)
        PopupBodyView(
            $info,
            $rights,
            $owner,
            $group
        ).frame(width: 300)
    }
    .padding(10)
    .background(Color.black)
    .frame(width: 320)
}
