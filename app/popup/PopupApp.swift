
/* ############################################################# */
/* ### Copyright © 2025 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import SwiftUI

struct FSEntityInfo {

    var type: FSType = .unknown
    var name: String?
    var path: String?
    var size: UInt?
    var created: Date?
    var updated: Date?
    var references: UInt?
    var rights: UInt = 0
    var owner: String = ""
    var group: String = ""

}

@main struct PopupApp: App {

    @Environment(\.scenePhase) var scenePhase

    static let FRAME_WIDTH: CGFloat = 300
    static let URL_PREFIX = "rwxEditor://"
    static let NA_SIGN = "—"

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    @State var incommingUrl: String = "" // "/Users/max/Desktop/" "/Users/max/Desktop/testDir/testDir2/testFile.txt"
    @State var fsEntityInfo: FSEntityInfo = FSEntityInfo()
    @State private var rights: UInt = 0
    @State private var owner: String = ""
    @State private var group: String = ""

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
                .onOpenURL { url in
                    let absolute = url.absoluteString
                    if (absolute.isEmpty == false) {
                        if (absolute[0, UInt(Self.URL_PREFIX.count-1)] == Self.URL_PREFIX) {
                            self.incommingUrl = String(
                                absolute[
                                    UInt(Self.URL_PREFIX.count),
                                    UInt(absolute.count-1)
                                ]
                            )
                            self.fsEntityInfo = self.analyzeURL(url: self.incommingUrl)
                            self.rights       = self.fsEntityInfo.rights
                            self.owner        = self.fsEntityInfo.owner
                            self.group        = self.fsEntityInfo.group
                        }
                    }
                }
        }.onChange(of: scenePhase) { phase in
            if (phase == .background) {
                NSApplication.shared.terminate(nil)
            }
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        VStack(spacing: 0) {
            #if DEBUG
                HStack {
                    let formattedIncommingUrl = String(format: "%@: %@", "url"   , self.incommingUrl.isEmpty ? Self.NA_SIGN : self.incommingUrl)
                    let formattedRights       = String(format: "%@: %@", "rights", String(self.fsEntityInfo.rights))
                    let formattedOwner        = String(format: "%@: %@", "owner" , self.fsEntityInfo.owner.isEmpty ? Self.NA_SIGN : self.fsEntityInfo.owner)
                    let formattedGroup        = String(format: "%@: %@", "group" , self.fsEntityInfo.group.isEmpty ? Self.NA_SIGN : self.fsEntityInfo.group)
                    Text("PopupApp: \(formattedIncommingUrl) | \(formattedRights) | \(formattedOwner) | \(formattedGroup)")
                        .fixedSize(horizontal: false, vertical: true)
                }
                .padding(10)
                .frame(maxWidth: .infinity, alignment: .leading)
                .foregroundPolyfill(Color(.white))
                .background(Color.gray)
            #endif
            PopupMainView(
                rights : self.$rights,
                owner  : self.$owner,
                group  : self.$group,
                info   : self.fsEntityInfo,
                onApply: self.onApply
            )
        }.frame(width: PopupApp.FRAME_WIDTH)
    }

    func analyzeURL(url: String) -> FSEntityInfo {
        var result = FSEntityInfo()
        if (!url.isEmpty) {
            if let attr = try? FileManager.default.attributesOfItem(atPath: url) {

                /* MARK: type */
                switch attr[.type] as? FileAttributeType {
                    case .typeRegular         : result.type = .file
                    case .typeDirectory       : result.type = .dirrectory
                    case .typeBlockSpecial    : result.type = .unknown
                    case .typeCharacterSpecial: result.type = .unknown
                    case .typeSocket          : result.type = .unknown
                    case .typeSymbolicLink    : result.type = .unknown
                    case .typeUnknown         : result.type = .unknown
                    case .none                : result.type = .unknown
                    case .some(_)             : result.type = .unknown
                }

                if (result.type == .file || result.type == .dirrectory) {

                    /* MARK: name/path */
                    if let urlAsURL = URL(string: url) {
                        result.name = urlAsURL.lastPathComponent
                        if (result.type == .dirrectory) { result.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - result.name!.count - 2)]) }
                        if (result.type == .file      ) { result.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - result.name!.count - 1)]) }
                    }

                    /* MARK: size */
                    if (result.type == .file) {
                        if let size = attr[.size] as? UInt {
                            result.size = size
                        }
                    }

                    /* MARK: created/updated/rights/owner/group/referenceCount */
                    if let created    = attr[.creationDate]          as? Date   { result.created    = created }
                    if let updated    = attr[.modificationDate]      as? Date   { result.updated    = updated }
                    if let references = attr[.referenceCount]        as? UInt   { result.references = references }
                    if let rights     = attr[.posixPermissions]      as? UInt   { result.rights     = rights }
                    if let owner      = attr[.ownerAccountName]      as? String { result.owner      = owner }
                    if let group      = attr[.groupOwnerAccountName] as? String { result.group      = group }

                }
            }
        }
        return result
    }

    init() {
        let owners = Process.systemUsers ().filter{ $0.first != "_" }.sorted()
        let groups = Process.systemGroups().filter{ $0.first != "_" }.sorted()
        if (Self.owners.isEmpty) {
            for value in owners {
                Self.owners[value] = value
            }
        }
        if (Self.groups.isEmpty) {
            for value in groups {
                Self.groups[value] = value
            }
        }
    }

    func onApply(rights: UInt, owner: String, group: String) {
        print("rights: \(String(rights, radix: 8)) | owner: \(owner) | group: \(group)")
    }

}

@available(macOS 14.0, *) #Preview {
    @Previewable @State var rights: UInt = 0o644
    PopupApp().mainScene
}
