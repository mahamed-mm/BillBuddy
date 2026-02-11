import Foundation

enum TipPreset: Int, CaseIterable, Identifiable {
    case zero, five, ten, fifteen, twenty, twentyFive, custom

    var id: Self { self }

    var percentage: Double {
        switch self {
        case .zero: 0
        case .five: 5
        case .ten: 10
        case .fifteen: 15
        case .twenty: 20
        case .twentyFive: 25
        case .custom: 0
        }
    }

    var displayText: String {
        self == .custom ? "Custom" : "\(Int(percentage))%"
    }
}
