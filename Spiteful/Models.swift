import Foundation

/// Someone you want to be spiteful towards (in a loving way).
struct Rival: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var emoji: String
    /// What they're up to, e.g. "painting", "marathon training"
    var project: String
    /// Both people must be in on it. Nobody gets ribbed without saying yes.
    var optedIn: Bool
    var status: Status = .pending

    enum Status: String, Codable {
        case pending, spited, passed
    }
}

enum Intensity: String, Codable, CaseIterable, Identifiable {
    case playful = "Playful"
    case theatrical = "Theatrical"
    case operatic = "Operatic"

    var id: String { rawValue }
    var flames: String {
        switch self {
        case .playful: return "🔥"
        case .theatrical: return "🔥🔥"
        case .operatic: return "🔥🔥🔥"
        }
    }
}

/// One round of fun ribbing and the follow up that keeps it going.
struct Spite: Identifiable, Codable {
    var id = UUID()
    var rivalID: UUID
    var task: String
    var roast: String
    var intensity: Intensity
    var createdAt = Date()
    var followUpAt: Date
    var round = 1
    var done = false
}
