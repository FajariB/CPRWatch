import SwiftUI

struct CPRToolbarContent: ToolbarContent {
    var body: some ToolbarContent {
        ToolbarItem(placement: .automatic) {
            VStack(spacing: 0) {
                Text("CPRWatch").font(.headline)
                Text("Timing assistant").font(.caption2).foregroundStyle(.secondary)
            }
            .accessibilityElement(children: .combine)
        }
    }
}

#Preview("CPR Toolbar") {
    NavigationStack {
        Text("Session content")
            .toolbar { CPRToolbarContent() }
    }
}
