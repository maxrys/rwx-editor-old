
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
