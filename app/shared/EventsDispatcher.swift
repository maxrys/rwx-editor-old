
import Foundation

class EventsDispatcher {

    static let shared = EventsDispatcher()

    let center: DistributedNotificationCenter = .default()

    var handlers: [
        String: (_ event: String) -> Void
    ] = [:]

    func send(_ type: String, object: String) {
        self.center.postNotificationName(
            NSNotification.Name(type),
            object: object,
            userInfo: nil,
            deliverImmediately: true
        )
    }

    func on(_ type: String, handler: @escaping (String) -> Void) {
        self.handlers[type] = handler
        self.center.addObserver(
            self,
            selector: #selector(onRecievedMessage(_:)),
            name: NSNotification.Name(type),
            object: nil
        )
    }

    @objc private func onRecievedMessage(_ notification: NSNotification) {
        guard let event   = notification.object as? String            else { return }
        guard let handler = self.handlers[notification.name.rawValue] else { return }
        handler(event)
    }

}
