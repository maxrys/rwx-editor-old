
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import Foundation

final class FSEntityInfo {

    var initUrl: String = ""
    var type: FSType = .unknown
    var path: String?
    var name: String?
    var realPath: String?
    var realName: String?
    var size: UInt?
    var created: Date?
    var updated: Date?
    var references: UInt?
    var rights: UInt = 0
    var owner: String = ""
    var group: String = ""

    init(_ initUrl: String) {

        guard initUrl.isEmpty == false else { return }

        self.initUrl = initUrl

        guard let url = URL(
            string: "file://\(self.initUrl)"
        ) else { return }

        guard let attr = try? FileManager.default.attributesOfItem(
            atPath: initUrl
        ) else { return }

        /* MARK: type */
        switch attr[.type] as? FileAttributeType {
            case .typeDirectory       : self.type = .directory
            case .typeRegular         : self.type = .file
            case .typeSymbolicLink    : self.type = .link
            case .typeBlockSpecial    : self.type = .unknown
            case .typeCharacterSpecial: self.type = .unknown
            case .typeSocket          : self.type = .unknown
            case .typeUnknown         : self.type = .unknown
            case .none                : self.type = .unknown
            case .some(_)             : self.type = .unknown
        }

        if let subtype = try? url.resourceValues(forKeys: [.isAliasFileKey, .isSymbolicLinkKey, .isRegularFileKey]) {
            switch (subtype.isRegularFile, subtype.isAliasFile, subtype.isSymbolicLink) {
                case (true, true, false):
                    self.type = .alias
                    self.realPath = "?"
                    self.realName = "?"
                case (false, true, true):
                    self.type = .link
                    let (realPath, realName) = url.resolvingSymlinksInPath().pathNameParts
                    self.realPath = realPath
                    self.realName = realName
                default: break
            }
        }

        if (self.type != .unknown) {

            /* MARK: name/path */
            let (path, name) = url.pathNameParts
            self.path = path
            self.name = name

            /* MARK: size */
            if (self.type == .file || self.type == .link) {
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
