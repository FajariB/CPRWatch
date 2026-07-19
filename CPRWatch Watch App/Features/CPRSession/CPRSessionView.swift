import Combine
import SwiftUI

struct CPRSessionView: View {
    @StateObject private var model = CPRSessionViewModel()
    @State private var showSafety = false

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if model.isRunning { activeView } else { setupView }
            }
            .padding(.horizontal, 8)
        }
        .sheet(isPresented: $showSafety) { safetyView }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { model.update(now: $0) }
    }

    private var setupView: some View {
        VStack(spacing: 12) {
            Text("CPRWatch").font(.headline)
            Text("Timing assistant").font(.caption).foregroundStyle(.secondary)
            Picker("Cadence", selection: $model.cadence) {
                ForEach(CadencePreset.allCases) { Text("\($0.rawValue) BPM").tag($0) }
            }
            Picker("Mode", selection: $model.mode) {
                ForEach(CPRMode.allCases) { Text($0.rawValue).tag($0) }
            }
            Button("Start CPR", action: model.start).buttonStyle(.borderedProminent)
            Button("Safety information") { showSafety = true }.font(.caption2)
        }
    }

    private var activeView: some View {
        VStack(spacing: 8) {
            Text(model.isPaused ? "PAUSED" : phaseTitle)
                .font(.headline)
                .foregroundStyle(model.isPaused ? .yellow : .red)
            Text(countLabel)
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .contentTransition(.numericText())
            Text("Cycle \(model.state.cycle)  •  \(formatted(model.state.elapsed))")
                .font(.caption).monospacedDigit()
            Text("\(model.cadence.rawValue) BPM").font(.caption2).foregroundStyle(.secondary)
            HStack {
                Button(model.isPaused ? "Resume" : "Pause", action: model.togglePause).buttonStyle(.bordered)
                Button("Stop", role: .destructive, action: model.stop).buttonStyle(.bordered)
            }
            if model.state.shouldRotate { Text("Switch compressor when safe").font(.caption2).foregroundStyle(.yellow) }
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

    private func formatted(_ duration: TimeInterval) -> String {
        let total = Int(duration)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

typealias ContentView = CPRSessionView

#Preview { CPRSessionView() }
