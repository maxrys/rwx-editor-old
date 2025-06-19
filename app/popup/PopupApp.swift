
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
    var rights: UInt = 0
    var owner: String = ""
    var group: String = ""

}

@main struct PopupApp: App {

    static let FRAME_WIDTH: CGFloat = 300
    static let URL_PREFIX = "rwxEditor://"
    static let NA_SIGN = "—"

    static var owners: [String: String] = [:]
    static var groups: [String: String] = [:]

    @State var receivedUrl: String = ""

    var body: some Scene {
        let window = WindowGroup {
            self.mainScene
                .environment(\.layoutDirection, .leftToRight)
                .onOpenURL { url in
                    let absolute = url.absoluteString
                    if (absolute.isEmpty == false) {
                        if (absolute[0, UInt(Self.URL_PREFIX.count-1)] == Self.URL_PREFIX) {
                            self.receivedUrl = String(
                                absolute[
                                    UInt(Self.URL_PREFIX.count),
                                    UInt(absolute.count-1)
                                ]
                            )
                        }
                    }
                }
        }
        if #available(macOS 13.0, *) { return window.windowResizability(.contentSize) }
        else                         { return window }
    }

    @ViewBuilder var mainScene: some View {
        VStack(spacing: 0) {
            #if DEBUG
                let text = String(format: NSLocalizedString("url: %@", comment: ""), self.receivedUrl.isEmpty ? Self.NA_SIGN : self.receivedUrl)
                let background = self.receivedUrl.isEmpty ?
                    Color.getCustom(.softRed) :
                    Color.getCustom(.softGreen)
                Text(text)
                    .padding(10)
                    .multilineTextAlignment(.center)
                    .fixedSize(horizontal: false, vertical: true)
                    .frame(maxWidth: .infinity)
                    .foregroundPolyfill(Color(.white))
                    .background(background)
            #endif
            PopupMainView(
                info: self.parseURL(url: self.receivedUrl),
                onApply: self.onApply
            )
        }.frame(width: PopupApp.FRAME_WIDTH)
    }

    func parseURL(url: String) -> FSEntityInfo {
        var result = FSEntityInfo()
        if (!url.isEmpty) {
            if let attr = try? FileManager.default.attributesOfItem(atPath: url) {

                /* type */
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

                    /* size */
                    if (result.type == .file) {
                        if let size = attr[.size] as? UInt {
                            result.size = size
                        }
                    }

                    /* other attributes */
                    if let created = attr[.creationDate]          as? Date   { result.created = created }
                    if let updated = attr[.modificationDate]      as? Date   { result.updated = updated }
                    if let rights  = attr[.posixPermissions]      as? UInt   { result.rights  = rights }
                    if let owner   = attr[.ownerAccountName]      as? String { result.owner   = owner }
                    if let group   = attr[.groupOwnerAccountName] as? String { result.group   = group }

                    /* name/path */
                    if let urlAsURL = URL(string: url) {
                        result.name = urlAsURL.lastPathComponent
                        if (result.type == .dirrectory) { result.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - result.name!.count - 2)]) }
                        if (result.type == .file      ) { result.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - result.name!.count - 1)]) }
                    }

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
