
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import QuartzCore
import Combine

extension Timer {

    final class Custom {

        enum Duration {
            case fixed(UInt)
            case infinity
        }

        public let tag: UInt
        public let duration: Duration
        public let interval: Double
        public private(set) var i: UInt = 0

        private let onTick: (Timer.Custom) -> Void
        private let onExpire: (Timer.Custom) -> Void
        private var timer: Cancellable?

        init(
            tag: UInt = 0,
            immediately: Bool = true,
            duration: Duration,
            interval: Double,
            onTick  : @escaping (Timer.Custom) -> Void = { _ in },
            onExpire: @escaping (Timer.Custom) -> Void = { _ in }
        ) {
            self.tag = tag
            self.duration = duration
            self.interval = interval
            self.onTick = onTick
            self.onExpire = onExpire
            if (immediately) {
                self.startOrRenew()
            }
        }

        func startOrRenew() {
            self.i = 0
            self.timer?.cancel()
            self.timer = Timer.publish(
                every: self.interval,
                tolerance: 0.0,
                on: RunLoop.main,
                in: RunLoop.Mode.common,
                options: nil
            ).autoconnect().sink(receiveValue: { _ in
                switch self.duration {
                    case .fixed(let count):
                        if (self.i < UInt.max) {
                            self.onTick(self)
                            self.i += 1
                            if (self.i > count - 1) {
                                self.stopAndReset()
                                self.onExpire(self)
                            }
                        }
                    case .infinity:
                        if (self.i < UInt.max) {
                            self.onTick(self)
                            self.i += 1
                        }
                }
            })
        }

        func stopAndReset() {
            self.timer?.cancel()
        }

    }

}
