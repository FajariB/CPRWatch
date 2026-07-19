import Foundation

enum CadencePreset: Int, CaseIterable, Identifiable {
    case slow = 100, standard = 110, fast = 120
    var id: Int { rawValue }
    var beatsPerMinute: Double { Double(rawValue) }
}

enum CPRMode: String, CaseIterable, Identifiable {
    case compressionOnly = "Compression-only"
    case thirtyToTwo = "30:2 guided"
    var id: String { rawValue }
}

enum CPRPhase: Equatable {
    case idle
    case compressions(count: Int)
    case breaths
    case paused
}

struct CPRSessionState: Equatable {
    let phase: CPRPhase
    let elapsed: TimeInterval
    let cycle: Int
    let shouldRotate: Bool
    let beat: Int
    static let idle = CPRSessionState(phase: .idle, elapsed: 0, cycle: 0, shouldRotate: false, beat: 0)
}

struct CPRSessionEngine {
    var cadence: CadencePreset = .standard
    var mode: CPRMode = .compressionOnly

    func state(elapsed: TimeInterval, paused: Bool = false) -> CPRSessionState {
        guard elapsed > 0 else { return .idle }
        let beat = beat(at: elapsed)
        if paused { return CPRSessionState(phase: .paused, elapsed: elapsed, cycle: cycle(at: elapsed), shouldRotate: false, beat: beat) }

        let position = beat % (mode == .thirtyToTwo ? 32 : 30)
        let phase: CPRPhase = mode == .thirtyToTwo && position >= 30
            ? .breaths
            : .compressions(count: position + 1)
        return CPRSessionState(phase: phase, elapsed: elapsed, cycle: cycle(at: elapsed), shouldRotate: rotationCue(at: elapsed), beat: beat)
    }

    private func beat(at elapsed: TimeInterval) -> Int {
        Int((elapsed * cadence.beatsPerMinute / 60).rounded(.down))
    }

    private func cycle(at elapsed: TimeInterval) -> Int {
        let beats = mode == .thirtyToTwo ? 32.0 : 30.0
        return max(1, Int(elapsed / (beats * 60 / cadence.beatsPerMinute)) + 1)
    }

    private func rotationCue(at elapsed: TimeInterval) -> Bool {
        elapsed >= 120 && Int(elapsed) % 120 <= 1
    }
}
