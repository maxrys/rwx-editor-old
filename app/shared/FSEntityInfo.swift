
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

struct FSEntityInfo {

    var incommingUrl: String = ""
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

    init(incommingUrl: String) {
        if (incommingUrl.isEmpty == false) {
            self.incommingUrl = incommingUrl
            if let attr = try? FileManager.default.attributesOfItem(atPath: incommingUrl) {

                /* MARK: type */
                switch attr[.type] as? FileAttributeType {
                    case .typeRegular         : self.type = .file
                    case .typeDirectory       : self.type = .dirrectory
                    case .typeBlockSpecial    : self.type = .unknown
                    case .typeCharacterSpecial: self.type = .unknown
                    case .typeSocket          : self.type = .unknown
                    case .typeSymbolicLink    : self.type = .unknown
                    case .typeUnknown         : self.type = .unknown
                    case .none                : self.type = .unknown
                    case .some(_)             : self.type = .unknown
                }

                if (self.type == .file || self.type == .dirrectory) {

                    /* MARK: name/path */
                    if let urlAsURL = URL(string: incommingUrl) {
                        self.name = urlAsURL.lastPathComponent
                        if (self.type == .dirrectory) { self.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - self.name!.count - 2)]) }
                        if (self.type == .file      ) { self.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - self.name!.count - 1)]) }
                    }

                    /* MARK: size */
                    if (self.type == .file) {
                        if let size = attr[.size] as? UInt {
                            self.size = size
                        }
                    }

                    /* MARK: created/updated/rights/owner/group/referenceCount */
                    if let created    = attr[.creationDate]          as? Date   { self.created    = created }
                    if let updated    = attr[.modificationDate]      as? Date   { self.updated    = updated }
                    if let references = attr[.referenceCount]        as? UInt   { self.references = references }
                    if let rights     = attr[.posixPermissions]      as? UInt   { self.rights     = rights }
                    if let owner      = attr[.ownerAccountName]      as? String { self.owner      = owner }
                    if let group      = attr[.groupOwnerAccountName] as? String { self.group      = group }

                }
            }
        }
    }

    static func forDemo() -> Self {
        var result = Self(incommingUrl: "")
            result.incommingUrl = "/Applications/Rwx Editor.app/Contents/Resources/AppIcon.icns"
            result.type = .file
            result.name = "AppIcon.icns"
            result.path = "/Applications/Rwx Editor.app/Contents/Resources/"
            result.size = 1_234_567
            result.created = try! Date(fromISO8601: "2025-01-02 03:04:05 +0000")
            result.updated = try! Date(fromISO8601: "2025-01-02 03:04:05 +0000")
            result.references = 5
            result.rights = 0o644
            result.owner = "nobody"
            result.group = "staff"
        return result
    }

}
