import Foundation

enum RoundingMode: Int, CaseIterable, Identifiable {
    case none, roundTip, roundTotal, roundPerPerson

    var id: Self { self }

    var displayText: String {
        switch self {
        case .none: "None"
        case .roundTip: "Tip ↑"
        case .roundTotal: "Total ↑"
        case .roundPerPerson: "Per Person ↑"
        }
    }
}
