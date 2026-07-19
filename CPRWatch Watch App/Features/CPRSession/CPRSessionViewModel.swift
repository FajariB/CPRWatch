import Combine
import Foundation

@MainActor
final class CPRSessionViewModel: ObservableObject {
    @Published var cadence: CadencePreset = .standard
    @Published var mode: CPRMode = .compressionOnly
    @Published private(set) var state = CPRSessionState.idle
    @Published private(set) var isRunning = false
    @Published private(set) var isPaused = false

    private let feedback: CPRSessionFeedback
    private var startedAt: Date?
    private var pausedAt: Date?
    private var accumulatedPause: TimeInterval = 0
    private var lastBeat = -1

    init(feedback: CPRSessionFeedback = WatchHapticFeedback()) {
        self.feedback = feedback
    }

    func start() {
        startedAt = Date()
        pausedAt = nil
        accumulatedPause = 0
        lastBeat = -1
        state = .idle
        isPaused = false
        isRunning = true
        feedback.start()
    }

    func togglePause() {
        if isPaused { resume() } else { pause() }
    }

    func pause() {
        guard isRunning, !isPaused else { return }
        pausedAt = Date()
        isPaused = true
        feedback.pause()
    }

    func resume() {
        guard isRunning, isPaused else { return }
        if let pausedAt { accumulatedPause += Date().timeIntervalSince(pausedAt) }
        self.pausedAt = nil
        isPaused = false
        feedback.resume()
    }

    func stop() {
        isRunning = false
        isPaused = false
        startedAt = nil
        pausedAt = nil
        accumulatedPause = 0
        lastBeat = -1
        state = .idle
        feedback.stop()
    }

    func update(now: Date) {
        guard isRunning, let startedAt else { return }
        let elapsed = max(0, now.timeIntervalSince(startedAt) - accumulatedPause)
        state = CPRSessionEngine(cadence: cadence, mode: mode).state(elapsed: elapsed, paused: isPaused)
        guard !isPaused, state.beat != lastBeat else { return }
        if state.phase.isCompression { feedback.compression() }
        lastBeat = state.beat
    }
}

private extension CPRPhase {
    var isCompression: Bool {
        if case .compressions = self { return true }
        return false
    }
}
