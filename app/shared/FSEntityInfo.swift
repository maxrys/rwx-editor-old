
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

    init(_ incommingUrl: String) {
        if (incommingUrl.isEmpty == false) {
            self.incommingUrl = incommingUrl
            if let attr = try? FileManager.default.attributesOfItem(atPath: incommingUrl) {

                /* MARK: type */
                switch attr[.type] as? FileAttributeType {
                    case .typeRegular         : self.type = .file
                    case .typeDirectory       : self.type = .dirrectory
                    case .typeSymbolicLink    : self.type = .link
                    case .typeBlockSpecial    : self.type = .unknown
                    case .typeCharacterSpecial: self.type = .unknown
                    case .typeSocket          : self.type = .unknown
                    case .typeUnknown         : self.type = .unknown
                    case .none                : self.type = .unknown
                    case .some(_)             : self.type = .unknown
                }

                if (self.type != .unknown) {

                    /* MARK: name/path */
                    if let urlAsURL = URL(string: incommingUrl) {
                        self.name = urlAsURL.lastPathComponent
                        if (self.type == .dirrectory) { self.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - self.name!.count - 2)]) }
                        if (self.type == .file      ) { self.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - self.name!.count - 1)]) }
                        if (self.type == .link      ) { self.path = String(urlAsURL.absoluteString[0, UInt(urlAsURL.absoluteString.count - self.name!.count - 1)]) }
                    }

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
    }

}
