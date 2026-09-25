import SwiftUI
import Testing
@testable import billBudy

// MARK: - Rounding Selector Layout

@Suite("RoundingSelectorView — Layout")
struct RoundingSelectorViewTests {

    @Test(
        "Standard text sizes wrap the four pills into two columns",
        arguments: [
            DynamicTypeSize.xSmall, .small, .medium, .large, .xLarge, .xxLarge, .xxxLarge
        ]
    )
    func standardSizesUseTwoColumns(size: DynamicTypeSize) {
        #expect(RoundingSelectorView.columnCount(for: size) == 2)
    }

    @Test(
        "Accessibility text sizes stack one pill per row",
        arguments: [
            DynamicTypeSize.accessibility1, .accessibility2, .accessibility3, .accessibility4, .accessibility5
        ]
    )
    func accessibilitySizesUseOneColumn(size: DynamicTypeSize) {
        #expect(RoundingSelectorView.columnCount(for: size) == 1)
    }
}
