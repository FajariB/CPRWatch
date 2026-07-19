import WatchKit

struct WatchHapticFeedback: CPRSessionFeedback {
    private let device = WKInterfaceDevice.current()

    func start() { device.play(.start) }
    func pause() { device.play(.stop) }
    func resume() { device.play(.start) }
    func stop() { device.play(.stop) }
    func compression() { device.play(.click) }
}
