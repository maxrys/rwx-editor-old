
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





    var body: some View {



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

    }

}
