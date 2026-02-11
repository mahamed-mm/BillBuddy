import Foundation

enum Currency: String, CaseIterable, Identifiable {
    case nok, usd, kes

    var id: Self { self }

    var symbol: String {
        switch self {
        case .nok: "kr"
        case .usd: "$"
        case .kes: "KSh"
        }
    }

    var flag: String {
        switch self {
        case .nok: "\u{1F1F3}\u{1F1F4}"
        case .usd: "\u{1F1FA}\u{1F1F8}"
        case .kes: "\u{1F1F0}\u{1F1EA}"
        }
    }

    var locale: String {
        switch self {
        case .nok: "nb_NO"
        case .usd: "en_US"
        case .kes: "en_KE"
        }
    }
}
