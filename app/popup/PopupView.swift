
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupView: View {

    static let FRAME_WIDTH: CGFloat = 300
    static let IS_SHOW_DEBUG_INFO = false

    private let messageBox: MessageBox
    private let initialValue: String

    @State private var info: FSEntityInfo
    @State private var rights: UInt
    @State private var owner: String
    @State private var group: String

    init(_ initialValue: String) {
        let info = FSEntityInfo(initialValue)
        self.messageBox   = MessageBox()
        self.initialValue = initialValue
        self.info         = info
        self.rights       = info.rights
        self.owner        = info.owner
        self.group        = info.group
    }

    func updateView(onlyIfRequired: Bool = false) {
        let info = FSEntityInfo(self.initialValue)
        if (onlyIfRequired && info == self.info) { return }
        self.info   = info
        self.rights = info.rights
        self.owner  = info.owner
        self.group  = info.group
    }

    var body: some View {
        VStack(spacing: 0) {

            /* MARK: head */
            HeadView(
                self.info
            )

            /* MARK: body */
            BodyView(
                self.$info,
                self.$rights,
                self.$owner,
                self.$group
            )

            /* MARK: foot */
            FootView(
                self.$info,
                self.$rights,
                self.$owner,
                self.$group,
                self.onCancel,
                self.onApply
            )

            /* MARK: message box */
            self.messageBox

            /* MARK: debug info */
            if (Self.IS_SHOW_DEBUG_INFO) {
                DebugInfoView(
                    self.$info
                )
            }

        }
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            self.updateView(onlyIfRequired: true)
        }
    }

    /* ############ */
    /* MARK: events */
    /* ############ */

    func onCancel() {
        self.updateView()
    }

    func onApply() {
        #if DEBUG
            print("onApply: url = \(self.info.initUrl) | rights = \(String(self.rights, radix: 8)) | owner = \(self.owner) | group = \(self.group)")
        #endif
        do {

            let fileURL = URL(fileURLWithPath: self.info.initUrl)
            try FileManager.default.setAttributes(
                [.posixPermissions     : self.rights,
                 .ownerAccountName     : self.owner,
                 .groupOwnerAccountName: self.group],
                ofItemAtPath: fileURL.path
            )

            self.updateView()
            self.messageBox.insert(
                type: .ok,
                title: NSLocalizedString(
                    "completed successfully", comment: ""
                )
            )

        } catch let error as NSError {
            switch error.code {
                case 513:
                    self.messageBox.insert(
                        type: .error,
                        title: NSLocalizedString("completed unsuccessfully", comment: ""),
                        description: NSLocalizedString("Application does not have permission to perform these actions!", comment: "")
                    )
                default:
                    self.messageBox.insert(
                        type: .error,
                        title: NSLocalizedString("completed unsuccessfully", comment: ""),
                        description: error.localizedDescription
                    )
            }
        } catch {
            self.messageBox.insert(
                type: .error,
                title: NSLocalizedString("completed unsuccessfully", comment: ""),
                description: error.localizedDescription
            )
        }
    }

}

#Preview {
    VStack(spacing: 10) {
        PopupView("/private/etc/")
        PopupView("/private/etc/hosts")
    }
    .padding(10)
    .background(Color.black)
}
