
/* ################################################################## */
/* ### Copyright © 2024—2025 Maxim Rysevets. All rights reserved. ### */
/* ################################################################## */

import SwiftUI

enum MessageType {

    enum ColorNames: String {
        case text                         = "color MessageBox Text"
        case infoTitleBackground          = "color MessageBox Info Title Background"
        case infoDescriptionBackground    = "color MessageBox Info Description Background"
        case okTitleBackground            = "color MessageBox Ok Title Background"
        case okDescriptionBackground      = "color MessageBox Ok Description Background"
        case warningTitleBackground       = "color MessageBox Warning Title Background"
        case warningDescriptionBackground = "color MessageBox Warning Description Background"
        case errorTitleBackground         = "color MessageBox Error Title Background"
        case errorDescriptionBackground   = "color MessageBox Error Description Background"
    }

    case info
    case ok
    case warning
    case error

    var colorTitleBackground: Color {
        switch self {
            case .info   : Color(Self.ColorNames.infoTitleBackground.rawValue)
            case .ok     : Color(Self.ColorNames.okTitleBackground.rawValue)
            case .warning: Color(Self.ColorNames.warningTitleBackground.rawValue)
            case .error  : Color(Self.ColorNames.errorTitleBackground.rawValue)
        }
    }

    var colorDescriptionBackground: Color {
        switch self {
            case .info   : Color(Self.ColorNames.infoDescriptionBackground.rawValue)
            case .ok     : Color(Self.ColorNames.okDescriptionBackground.rawValue)
            case .warning: Color(Self.ColorNames.warningDescriptionBackground.rawValue)
            case .error  : Color(Self.ColorNames.errorDescriptionBackground.rawValue)
        }
    }

}

struct Message: Hashable {

    let type: MessageType
    let title: String
    let description: String

    init(type: MessageType, title: String, description: String = "") {
        self.title = title
        self.description = description
        self.type = type
    }

}

struct MessageBox: View {

//    typealias MessagesCollection = [
//        UInt: (
//            message: Message,
//            expirationTimer: RealTimer?
//        )
//    ]

    static var MESSAGE_LIFE_TIME: Double = 3.0

    @State private var messages: [UInt: Message] = [:]
    @State private var counter: UInt = 0

    init() {
    }

//    func onTimerTick(offset: Double, timer: RealTimer) {
//        timer.stopAndReset()
//        self.messages[timer.tag] = nil
//    }

    var body: some View {
        VStack (spacing: 0) {
            ForEach(self.messages.sorted(by: { (lhs, rhs) in lhs.key < rhs.key }), id: \.key) { id, item in
                VStack(spacing: 0) {
                    Text(NSLocalizedString(item.title, comment: ""))
                        .font(.system(size: 14, weight: .bold))
                        .multilineTextAlignment(.center)
                        .fixedSize(horizontal: false, vertical: true)
                        .padding(13)
                        .frame(maxWidth: .infinity)
                        .background(item.type.colorTitleBackground)
                    if (!item.description.isEmpty) {
                        Text(NSLocalizedString(item.description, comment: ""))
                            .font(.system(size: 13))
                            .multilineTextAlignment(.center)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(13)
                            .frame(maxWidth: .infinity)
                            .background(item.type.colorDescriptionBackground)
                    }
                }
                .foregroundPolyfill(Color(MessageType.ColorNames.text.rawValue))
                .frame(maxWidth: .infinity)
            }
        }
//        .onReceive(self.publisherForInsert) { publisher in
//            if let message = publisher.object as? Message {
//                let expirationTimer = RealTimer(
//                    tag: id,
//                    onTick: self.onTimerTick
//                )
//                self.messages[id] = (
//                    message: message,
//                    expirationTimer: expirationTimer
//                )
//                expirationTimer.start(
//                    tickInterval: Self.MESSAGE_LIFE_TIME
//                )
//            }
//        }
    }

    func insert(type: MessageType, title: String, description: String = "") {
        self.messages[self.counter] = Message(type: type, title: title, description: description)
        self.counter += 1
    }

}

#Preview {
    let messageBox: MessageBox = {
        let messageBox = MessageBox()
            messageBox.insert(type: .info   , title: "Info")
            messageBox.insert(type: .ok     , title: "Ok")
            messageBox.insert(type: .warning, title: "Warning")
            messageBox.insert(type: .error  , title: "Error")
            messageBox.insert(type: .info   , title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            messageBox.insert(type: .ok     , title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            messageBox.insert(type: .warning, title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
            messageBox.insert(type: .error  , title: "Lorem ipsum dolor sit amet", description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.")
        return messageBox
    }()
    messageBox
        .padding(10)
        .frame(width: 200)
}
