import Combine
import SwiftUI

struct CPRSessionView: View {
    @StateObject private var model = CPRSessionViewModel()
    @State private var showSafety = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ScrollView {
            VStack(spacing: 12) {
                if model.isRunning { activeView } else { setupView }
            }
            .padding(.horizontal, 10)
        }
        .sheet(isPresented: $showSafety) { safetyView }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { model.update(now: $0) }
    }

    private var setupView: some View {
        VStack(alignment: .leading, spacing: 12) {
            VStack(alignment: .leading, spacing: 2) {
                Text("CPRWatch").font(.title3.weight(.semibold))
                Text("Timing assistant").font(.caption).foregroundStyle(.secondary)
            }
            Picker("Cadence", selection: $model.cadence) {
                ForEach(CadencePreset.allCases) { Text("\($0.rawValue) BPM").tag($0) }
            }.accessibilityHint("Choose a compression cadence")
            Picker("Mode", selection: $model.mode) {
                ForEach(CPRMode.allCases) { Text($0.rawValue).tag($0) }
            }.accessibilityHint("Choose compression-only or 30 to 2 guidance")
            Button("Start CPR", action: model.start)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity, minHeight: 44)
            Button("Safety information") { showSafety = true }
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
    }

    private var activeView: some View {
        VStack(spacing: 10) {
            Text(model.isPaused ? "PAUSED" : phaseTitle)
                .font(.headline.weight(.semibold))
                .foregroundStyle(model.isPaused ? .yellow : .red)
                .accessibilityAddTraits(.isHeader)
            Circle()
                .fill(model.isPaused ? .yellow : .red)
                .frame(width: 14, height: 14)
                .scaleEffect(reduceMotion || model.isPaused ? 1 : 1.25)
                .animation(reduceMotion ? nil : .easeOut(duration: 0.18), value: model.state.beat)
                .accessibilityHidden(true)
            Text(countLabel)
                .font(.system(size: 52, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
                .accessibilityLabel(countAccessibilityLabel)
            Text("Cycle \(model.state.cycle)  •  \(formatted(model.state.elapsed))")
                .font(.caption).monospacedDigit().foregroundStyle(.secondary)
                .accessibilityLabel("Cycle \(model.state.cycle), elapsed time \(formatted(model.state.elapsed))")
            Text("\(model.cadence.rawValue) BPM").font(.caption2).foregroundStyle(.secondary)
                .accessibilityLabel("Cadence \(model.cadence.rawValue) compressions per minute")
            HStack {
                Button(model.isPaused ? "Resume" : "Pause", action: model.togglePause)
                    .buttonStyle(.bordered).controlSize(.large).frame(minWidth: 78, minHeight: 44)
                Button("Stop", role: .destructive, action: model.stop)
                    .buttonStyle(.bordered).controlSize(.large).frame(minWidth: 78, minHeight: 44)
            }
            if model.state.shouldRotate {
                Label("Switch compressor when safe", systemImage: "person.2")
                    .font(.caption2).foregroundStyle(.yellow)
                    .multilineTextAlignment(.center)
            }
        }
    }

    private var safetyView: some View {
        Text("Call local emergency services and follow dispatcher and AED instructions. CPRWatch only provides timing assistance.")
            .font(.footnote).padding()
    }

    private var phaseTitle: String {
        if case .breaths = model.state.phase { return "BREATHS" }
        return "COMPRESSIONS"
    }

    private var countLabel: String {
        if case let .compressions(count) = model.state.phase { return "\(count)" }
        if case .breaths = model.state.phase { return "2" }
        return "—"
    }

    private var countAccessibilityLabel: String {
        if case .breaths = model.state.phase { return "Give 2 breaths" }
        if case let .compressions(count) = model.state.phase { return "Compression \(count) of 30" }
        return model.isPaused ? "Session paused" : "Ready"
    }

    private func formatted(_ duration: TimeInterval) -> String {
        let total = Int(duration)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

#Preview { CPRSessionView() }
