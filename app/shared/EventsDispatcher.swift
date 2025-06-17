
import Foundation
import Combine

class EventsDispatcher {

    static let shared = EventsDispatcher()

    private var cancellableBag = Set<AnyCancellable>()
    private var publisherBag: [
        String: NotificationCenter.Publisher
    ] = [:]
    private var handlers: [
        String: [(String) -> Void]
    ] = [:]

    func publisher( _ type: String) -> NotificationCenter.Publisher? {
        if (self.publisherBag[type] == nil) {
            self.publisherBag[type] = DistributedNotificationCenter.default.publisher(for: Notification.Name(type))
            self.publisherBag[type]!.sink(receiveValue: { notification in
                for handler in self.handlers[type] ?? [] {
//                    handler(notification.object!)
                }
            }).store(in: &self.cancellableBag)
        }
        return self.publisherBag[type]!
    }

    func send(_ type: String, object: String) {
        DistributedNotificationCenter.default().postNotificationName(
            NSNotification.Name(type),
            object: object,
            deliverImmediately: true
        )
    }

    func on(_ type: String, handler: @escaping (String) -> Void) {
        if (self.handlers[type] == nil) { self.handlers[type] = [] }
        self.handlers[type]!.append(handler)

        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(onRecievedMessage(_:)),
            name: NSNotification.Name(type),
            object: nil
        )
    }

    @objc private func onRecievedMessage(_ notification: NSNotification) {
        guard let event = notification.object as? String else { return }
        for handler in self.handlers[notification.name.rawValue] ?? [] {
            handler(event)
        }
    }

}
