import SwiftUI

struct SafetyInformationView: View {
    var body: some View {
        Text("Call local emergency services and follow dispatcher and AED instructions. CPRWatch only provides timing assistance.")
            .font(.footnote)
            .padding()
    }
}


#Preview("Safety Information") { SafetyInformationView() }
