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

    @Test("Two columns give two rows of two pills, in display order")
    func rowsOfTwo() {
        #expect(RoundingSelectorView.rows(columnCount: 2) == [
            [RoundingMode.none, .roundTip],
            [.roundTotal, .roundPerPerson]
        ])
    }

    @Test("One column gives one pill per row, in display order")
    func rowsOfOne() {
        #expect(RoundingSelectorView.rows(columnCount: 1) == RoundingMode.allCases.map { [$0] })
    }

    @Test(
        "Any column count keeps every mode exactly once, in order, with no empty or oversized rows",
        arguments: [0, 1, 2, 3, 4, 5]
    )
    func rowsKeepEveryModeInOrder(columnCount: Int) {
        let rows = RoundingSelectorView.rows(columnCount: columnCount)
        #expect(rows.flatMap { $0 } == RoundingMode.allCases)
        #expect(rows.allSatisfy { !$0.isEmpty && $0.count <= max(columnCount, 1) })
    }
}
