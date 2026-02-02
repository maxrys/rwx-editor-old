
/* ############################################################# */
/* ### Copyright © 2026 Maxim Rysevets. All rights reserved. ### */
/* ############################################################# */

import QuartzCore
import Combine

extension Timer {

    final class Custom {

        public let tag: UInt
        public let count: UInt16
        public let interval: Double
        public private(set) var i: UInt16 = 0

        private let onTick: (Timer.Custom) -> Void
        private let onExpire: (Timer.Custom) -> Void
        private var timer: Cancellable?

        init(
            tag: UInt = 0,
            immediately: Bool = true,
            count: UInt16,
            interval: Double,
            onTick  : @escaping (Timer.Custom) -> Void = { _ in },
            onExpire: @escaping (Timer.Custom) -> Void = { _ in }
        ) {
            self.tag = tag
            self.count = count
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
                self.onTick(self)
                self.i += 1
                if (self.i > self.count - 1) {
                    self.stopAndReset()
                    self.onExpire(self)
                }
            })
        }

        func stopAndReset() {
            self.timer?.cancel()
        }

    }

}
