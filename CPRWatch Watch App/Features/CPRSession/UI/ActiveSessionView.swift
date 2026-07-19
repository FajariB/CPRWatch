import Foundation
import SwiftUI

struct ActiveSessionView: View {
    let state: CPRSessionState
    let cadence: CadencePreset
    let isPaused: Bool
    let onTogglePause: () -> Void
    let onStop: () -> Void
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        VStack(spacing: 10) {
            Text(isPaused ? "PAUSED" : phaseTitle)
                .font(.headline.weight(.semibold))
                .foregroundStyle(isPaused ? .yellow : .red)
                .accessibilityAddTraits(.isHeader)
            Circle()
                .fill(isPaused ? .yellow : .red)
                .frame(width: 14, height: 14)
                .scaleEffect(reduceMotion || isPaused ? 1 : 1.25)
                .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: state.beat)
                .accessibilityHidden(true)
            Text(countLabel)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .accessibilityLabel(countAccessibilityLabel)
            Text("Cycle \(state.cycle)  •  \(formatted(state.elapsed))")
                .font(.caption).monospacedDigit().foregroundStyle(.secondary)
                .accessibilityLabel("Cycle \(state.cycle), elapsed time \(formatted(state.elapsed))")
            Text("\(cadence.rawValue) BPM").font(.caption2).foregroundStyle(.secondary)
                .accessibilityLabel("Cadence \(cadence.rawValue) compressions per minute")
            HStack {
                Button(isPaused ? "Resume" : "Pause", action: onTogglePause)
                    .buttonStyle(.bordered).controlSize(.large).frame(minWidth: 78, minHeight: 44)
                Button("Stop", role: .destructive, action: onStop)
                    .buttonStyle(.bordered).controlSize(.large).frame(minWidth: 78, minHeight: 44)
            }
            if state.shouldRotate {
                Label("Switch compressor when safe", systemImage: "person.2")
                    .font(.caption2).foregroundStyle(.yellow).multilineTextAlignment(.center)
            }
        }
    }

    private var phaseTitle: String { if case .breaths = state.phase { return "BREATHS" }; return "COMPRESSIONS" }
    private var countLabel: String { if case let .compressions(count) = state.phase { return "\(count)" }; if case .breaths = state.phase { return "2" }; return "—" }
    private var countAccessibilityLabel: String { if case .breaths = state.phase { return "Give 2 breaths" }; if case let .compressions(count) = state.phase { return "Compression \(count) of 30" }; return isPaused ? "Session paused" : "Ready" }
    private func formatted(_ duration: TimeInterval) -> String { let total = Int(duration); return String(format: "%02d:%02d", total / 60, total % 60) }
}
