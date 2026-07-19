import Combine
import SwiftUI

struct CPRSessionView: View {
    @StateObject private var model = CPRSessionViewModel()
    @State private var showSafety = false

    var body: some View {
        NavigationStack {
            ScrollView {
                Group {
                    if model.isRunning {
                        ActiveSessionView(
                            state: model.state,
                            cadence: model.cadence,
                            isPaused: model.isPaused,
                            onTogglePause: model.togglePause,
                            onStop: model.stop
                        )
                    } else {
                        SessionSetupView(
                            cadence: $model.cadence,
                            mode: $model.mode,
                            onStart: model.start,
                            onShowSafety: { showSafety = true }
                        )
                    }
                }
                .padding(.horizontal, 6)
            }
            .toolbar { CPRToolbarContent() }
        }
        .sheet(isPresented: $showSafety) { SafetyInformationView() }
        .onReceive(Timer.publish(every: 0.05, on: .main, in: .common).autoconnect()) {
            model.update(now: $0)
        }
    }
}

#Preview { CPRSessionView() }
