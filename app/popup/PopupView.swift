
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct PopupView: View {

    enum ColorNames: String {
        case body = "color PopupView Body Background"
        case foot = "color PopupView Foot Background"
    }

    static let NA_SIGN = "—"
    static let FRAME_WIDTH: CGFloat = 300
    static let IS_SHOW_DEBUG_INFO = false

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

    @Environment(\.scenePhase)  private var scenePhase
    @Environment(\.colorScheme) private var colorScheme

    @State private var rights: UInt = 0
    @State private var owner: String = ""
    @State private var group: String = ""
    @State private var info: FSEntityInfo

    private let initialPathWithName: String
    private let messageBox = MessageBox()

    init(_ initialPathWithName: String) {
        self.initialPathWithName = initialPathWithName
        let fsEntityInfo = FSEntityInfo(initialPathWithName)
        self.rights = fsEntityInfo.rights
        self.owner  = fsEntityInfo.owner
        self.group  = fsEntityInfo.group
        self.info   = fsEntityInfo
    }

    var body: some View {
        VStack(spacing: 0) {

            /* ########## */
            /* MARK: head */
            /* ########## */

            HeadView(self.info)

            /* ########## */
            /* MARK: body */
            /* ########## */

            VStack(spacing: 20) {

                /* shadow */
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
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.r.offset)
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.r.offset)
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.r.offset)
                    }

                    VStack(spacing: 10) {
                        Text(NSLocalizedString("Write", comment: "")).frame(width: textW, height: textH)
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.w.offset)
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.w.offset)
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.w.offset)
                    }

                    VStack(spacing: 10) {
                        let text = self.info.type == .file ? "Execute" : "Access"
                        Text(NSLocalizedString(text, comment: "")).frame(width: textW, height: textH)
                        ToggleRwxColored(.owner, self.$rights, bitPosition: Subject.owner.offset + Permission.x.offset);
                        ToggleRwxColored(.group, self.$rights, bitPosition: Subject.group.offset + Permission.x.offset);
                        ToggleRwxColored(.other, self.$rights, bitPosition: Subject.other.offset + Permission.x.offset);
                    }

                }

                /* MARK: rules via text/numeric */
                HStack(spacing: 20) {
                    RwxTextView(self.$rights)
                    ToggleRwxNumeric(self.$rights)
                }

                VStack(alignment: .trailing, spacing: 10) {

                    /* MARK: owner picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Owner", comment: ""))
                        PickerCustom<String>(
                            selected: self.$owner,
                            values: self.owners,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                    /* MARK: group picker */
                    HStack(spacing: 10) {
                        Text(NSLocalizedString("Group", comment: ""))
                        PickerCustom<String>(
                            selected: self.$group,
                            values: self.groups,
                            isPlainListStyle: true,
                            flexibility: .size(150)
                        )
                    }

                }.padding(.top, 10)

                /* shadow */
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
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.body.rawValue))

            /* ########## */
            /* MARK: foot */
            /* ########## */

            HStack(spacing: 10) {

                let isNotChanged: Bool =
                    self.rights == self.info.rights &&
                    self.owner  == self.info.owner  &&
                    self.group  == self.info.group

                /* MARK: cancel button */
                ButtonCustom(NSLocalizedString("cancel", comment: ""), flexibility: .size(100)) {
                    self.rights = self.info.rights
                    self.owner  = self.info.owner
                    self.group  = self.info.group
                }.disabled(isNotChanged)

                /* MARK: apply button */
                ButtonCustom(NSLocalizedString("apply", comment: ""), flexibility: .size(100)) {
                    self.onApply(
                        rights: self.rights,
                        owner : self.owner,
                        group : self.group
                    )
                }.disabled(isNotChanged || self.info.type == .unknown)

            }
            .padding(25)
            .frame(maxWidth: .infinity)
            .background(Color(Self.ColorNames.foot.rawValue))

            /* ################# */
            /* MARK: message box */
            /* ################# */

            self.messageBox

            /* ################ */
            /* MARK: debug info */
            /* ################ */

            if (Self.IS_SHOW_DEBUG_INFO) {
                #if DEBUG
                    HStack {
                        let debugInfo: [String] = [
                            String(format: "%@: %@", "state rights", String(self.rights)),
                            String(format: "%@: %@", "state owner" , self.owner.isEmpty ? Self.NA_SIGN : self.owner),
                            String(format: "%@: %@", "state group" , self.group.isEmpty ? Self.NA_SIGN : self.group),
                            String(format: "%@: %@", "rights"      , String(self.info.rights)),
                            String(format: "%@: %@", "owner"       , self.info.owner.isEmpty ? Self.NA_SIGN : self.info.owner),
                            String(format: "%@: %@", "group"       , self.info.group.isEmpty ? Self.NA_SIGN : self.info.group),
                            String(format: "%@: %@", "url"         , String(self.info.initUrl)),
                        ]
                        Text("Debug: \(debugInfo.joined(separator: " | "))")
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(10)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .foregroundPolyfill(Color(.white))
                    .background(Color.gray)
                #endif
            }

        }
        .foregroundPolyfill(Color.getCustom(.text))
        .environment(\.layoutDirection, .leftToRight)
        .frame(width: Self.FRAME_WIDTH)
        .onReceive(NotificationCenter.default.publisher(for: NSApplication.didBecomeActiveNotification)) { _ in
            self.updateView(onlyIfRequired: true)
        }
    }

    func updateView(onlyIfRequired: Bool = false) {
        let fsEntityInfo = FSEntityInfo(self.initialPathWithName)
        if (onlyIfRequired && fsEntityInfo == self.info) { return }
        self.rights = fsEntityInfo.rights
        self.owner  = fsEntityInfo.owner
        self.group  = fsEntityInfo.group
        self.info   = fsEntityInfo
    }

    /* ################### */
    /* MARK: apply changes */
    /* ################### */

    func onApply(rights: UInt, owner: String, group: String) {
        #if DEBUG
            print("onApply: url = \(self.info.initUrl) | rights = \(String(rights, radix: 8)) | owner = \(owner) | group = \(group)")
        #endif
        do {

            let fileURL = URL(fileURLWithPath: self.info.initUrl)
            try FileManager.default.setAttributes(
                [.posixPermissions: rights,
                 .ownerAccountName: owner,
                 .groupOwnerAccountName: group],
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
