import SwiftUI

struct SessionSetupView: View {
    @Binding var cadence: CadencePreset
    @Binding var mode: CPRMode
    let onStart: () -> Void
    let onShowSafety: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Picker("Cadence", selection: $cadence) {
                ForEach(CadencePreset.allCases) { Text("\($0.rawValue) BPM").tag($0) }
            }
            .frame(maxWidth: .infinity)
            .accessibilityHint("Choose a compression cadence")

            Picker("Mode", selection: $mode) {
                ForEach(CPRMode.allCases) { Text($0.rawValue).tag($0) }
            }
            .frame(maxWidth: .infinity)
            .accessibilityHint("Choose compression-only or 30 to 2 guidance")

            Button("Start CPR", action: onStart)
                .buttonStyle(.borderedProminent)
                .controlSize(.large)
                .frame(maxWidth: .infinity, minHeight: 44)
            Button("Safety information", action: onShowSafety)
                .font(.caption)
                .frame(maxWidth: .infinity, minHeight: 44)
        }
    }
}
