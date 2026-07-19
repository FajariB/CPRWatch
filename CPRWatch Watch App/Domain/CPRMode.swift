enum CPRMode: String, CaseIterable, Identifiable {
    case compressionOnly = "Compression-only"
    case thirtyToTwo = "30:2 guided"

    var id: String { rawValue }
}
