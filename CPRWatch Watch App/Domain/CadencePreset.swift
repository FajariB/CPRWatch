enum CadencePreset: Int, CaseIterable, Identifiable {
    case slow = 100
    case standard = 110
    case fast = 120

    var id: Int { rawValue }
    var beatsPerMinute: Double { Double(rawValue) }
}
