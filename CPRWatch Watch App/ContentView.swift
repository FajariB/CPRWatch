import SwiftUI
import WatchKit

struct ContentView: View {
    @State private var cadence: CadencePreset = .standard
    @State private var mode: CPRMode = .compressionOnly
    @State private var isRunning = false
    @State private var isPaused = false
    @State private var startedAt: Date?
    @State private var pausedAt: Date?
    @State private var accumulatedPause: TimeInterval = 0
    @State private var state = CPRSessionState.idle
    @State private var lastBeat = -1
    @State private var showSafety = false

    private var engine: CPRSessionEngine { CPRSessionEngine(cadence: cadence, mode: mode) }

    var body: some View {
        ScrollView {
            VStack(spacing: 10) {
                if !isRunning {
                    setupView
                } else {
                    activeView
                }
            }
            .padding(.horizontal, 8)
        }
        .sheet(isPresented: $showSafety) {
            Text("Call local emergency services and follow dispatcher and AED instructions. CPRWatch only provides timing assistance.")
                .font(.footnote)
                .padding()
        }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) { now in
            guard isRunning, let startedAt else { return }
            let elapsed = max(0, now.timeIntervalSince(startedAt) - accumulatedPause)
            state = engine.state(elapsed: elapsed, paused: isPaused)
            if !isPaused, state.beat != lastBeat {
                if state.phase.isCompression { WKInterfaceDevice.current().play(.click) }
                lastBeat = state.beat
            }
        }
    }

    private var setupView: some View {
        VStack(spacing: 12) {
            Text("CPRWatch").font(.headline)
            Text("Timing assistant").font(.caption).foregroundStyle(.secondary)

            Picker("Cadence", selection: $cadence) {
                ForEach(CadencePreset.allCases) { preset in
                    Text("\(preset.rawValue) BPM").tag(preset)
                }
            }
            Picker("Mode", selection: $mode) {
                ForEach(CPRMode.allCases) { mode in Text(mode.rawValue).tag(mode) }
            }
            Button("Start CPR") { start() }.buttonStyle(.borderedProminent)
            Button("Safety information") { showSafety = true }.font(.caption2)
        }
    }

    private var activeView: some View {
        VStack(spacing: 8) {
            Text(isPaused ? "PAUSED" : phaseTitle).font(.headline).foregroundStyle(isPaused ? .yellow : .red)
            Text(countLabel).font(.system(size: 42, weight: .bold, design: .rounded)).contentTransition(.numericText())
            Text("Cycle \(state.cycle)  •  \(formatted(state.elapsed))").font(.caption).monospacedDigit()
            Text("\(cadence.rawValue) BPM").font(.caption2).foregroundStyle(.secondary)

            HStack {
                Button(isPaused ? "Resume" : "Pause") { togglePause() }.buttonStyle(.bordered)
                Button("Stop", role: .destructive) { stop() }.buttonStyle(.bordered)
            }
            if state.shouldRotate { Text("Switch compressor when safe").font(.caption2).foregroundStyle(.yellow) }
        }
    }

    private var phaseTitle: String {
        if case .breaths = state.phase { return "BREATHS" }
        return "COMPRESSIONS"
    }

    private var countLabel: String {
        if case let .compressions(count) = state.phase { return "\(count)" }
        if case .breaths = state.phase { return "2" }
        return "—"
    }

    private func start() {
        startedAt = Date()
        accumulatedPause = 0
        state = .idle
        lastBeat = -1
        isPaused = false
        isRunning = true
        WKInterfaceDevice.current().play(.start)
    }

    private func togglePause() {
        if isPaused {
            if let pausedAt { accumulatedPause += Date().timeIntervalSince(pausedAt) }
            self.pausedAt = nil
            isPaused = false
            WKInterfaceDevice.current().play(.start)
        } else {
            pausedAt = Date()
            isPaused = true
            WKInterfaceDevice.current().play(.stop)
        }
    }

    private func stop() {
        isRunning = false
        isPaused = false
        startedAt = nil
        pausedAt = nil
        state = .stopped
        WKInterfaceDevice.current().play(.stop)
    }

    private func formatted(_ duration: TimeInterval) -> String {
        let total = Int(duration)
        return String(format: "%02d:%02d", total / 60, total % 60)
    }
}

private extension CPRPhase {
    var isCompression: Bool {
        if case .compressions = self { return true }
        return false
    }
}

#Preview { ContentView() }
