import Foundation

/// How the bill is split between people: in `equal` shares, or by `custom` amounts per person
/// (see `PersonSplit`).
enum SplitMode: Int, CaseIterable, Identifiable {
    case equal, custom

    var id: Self { self }

    var displayText: String {
        switch self {
        case .equal: "Equal"
        case .custom: "Custom"
        }
    }
}
