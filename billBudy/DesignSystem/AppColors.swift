import SwiftUI
import UIKit

enum AppColors {
    // MARK: - Brand

    static let bbTeal = Color(red: 0, green: 0.898, blue: 0.8) // #00E5CC

    // MARK: - Backgrounds

    static let bbBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.039, green: 0.039, blue: 0.058, alpha: 1) // #0A0A0F
            : UIColor(red: 0.949, green: 0.949, blue: 0.969, alpha: 1) // #F2F2F7
    })

    static let bbCardBackground = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0.110, green: 0.110, blue: 0.118, alpha: 1) // #1C1C1E
            : UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1) // #FFFFFF
    })

    // MARK: - Text

    static let bbPrimaryText = Color.primary

    static let bbSecondaryText = Color.secondary

    // MARK: - Chips & Selection

    static let bbSelectedChip = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(red: 0, green: 0.898, blue: 0.8, alpha: 0.15)
            : UIColor(red: 0, green: 0.898, blue: 0.8, alpha: 0.10)
    })

    static let bbSelectedBorder = bbTeal

    static let bbUnselectedBorder = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor.systemGray3 // #3A3A3C — lighter in dark for visibility
            : UIColor.systemGray4 // #D1D1D6
    })

    // MARK: - Card Surface

    static let bbCardBorder = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 1.0, alpha: 0.08) // subtle glass edge
            : UIColor(white: 0.0, alpha: 0.04) // barely visible
    })

    static let bbCardShadow = Color(UIColor { traits in
        traits.userInterfaceStyle == .dark
            ? UIColor(white: 0.0, alpha: 0.4) // deeper shadow for elevation
            : UIColor(white: 0.0, alpha: 0.08) // soft light-mode shadow
    })
}
