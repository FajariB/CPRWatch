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
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity,minHeight: 48)
            .accessibilityHint("Choose a compression cadence")

            Picker("Mode", selection: $mode) {
                ForEach(CPRMode.allCases) { Text($0.rawValue).tag($0) }
            }
            .pickerStyle(.wheel)
            .labelsHidden()
            .frame(maxWidth: .infinity,minHeight: 48)
            .frame(maxWidth: .infinity)
            
            .accessibilityHint("Choose compression-only or 30 to 2 guidance")
            HStack{
                Button("Start CPR", action: onStart)
                    .buttonStyle(.borderedProminent)
                    .controlSize(.large)
                    .frame(maxWidth: .infinity, minHeight: 44)
                Button(action: onShowSafety){
                    Image(systemName: "info.circle")
                }
                .buttonStyle(.bordered)
                .cornerRadius(100)
                .frame(maxWidth: 48, minHeight: 48)

            }
        }
    }
}

private struct SessionSetupPreview: View {
    @State private var cadence = CadencePreset.standard
    @State private var mode = CPRMode.compressionOnly

    var body: some View {
        ScrollView {
            SessionSetupView(
                cadence: $cadence,
                mode: $mode,
                onStart: {},
                onShowSafety: {}
            )
            .padding(.horizontal, 4)
        }
    }
}

#Preview("Session Setup") { SessionSetupPreview() }
