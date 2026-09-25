import Testing
@testable import billBudy

// MARK: - Allocation

@Suite("ShareAllocator — Allocation")
struct ShareAllocatorTests {

    @Test(
        "Equal weights add up exactly and differ by at most 1",
        arguments: 1...20, [0, 1, 99, 100, 101, 11_500, 99_999_999]
    )
    func equalWeights(count: Int, total: Int) throws {
        let shares = ShareAllocator.allocate(total, weights: Array(repeating: 1, count: count))
        expectExactSplit(shares, of: total, count: count)
        let largest = try #require(shares.max())
        let smallest = try #require(shares.min())
        #expect(largest - smallest <= 1)
    }

    @Test(
        "Unequal weights add up exactly, each share within 1 minor unit of its exact proportion",
        arguments: 1...20, [0, 1, 99, 100, 101, 11_500, 99_999_999]
    )
    func unequalWeights(count: Int, total: Int) {
        let weights = (1...count).map { $0 % 4 } // 1, 2, 3, 0, 1, …: ties and zero weights
        let shares = ShareAllocator.allocate(total, weights: weights)
        expectExactSplit(shares, of: total, count: count)
        expectProportional(shares, of: total, weights: weights)
    }

    @Test("Leftover units go to the lowest index when remainders tie")
    func tiesGoToLowestIndex() {
        #expect(ShareAllocator.allocate(10_000, weights: [1, 1, 1]) == [3334, 3333, 3333])
        #expect(ShareAllocator.allocate(10_001, weights: [1, 1, 1]) == [3334, 3334, 3333])
        #expect(ShareAllocator.allocate(1, weights: [1, 1, 1]) == [1, 0, 0])
        #expect(ShareAllocator.allocate(5, weights: [1, 1, 1, 1, 1, 1]) == [1, 1, 1, 1, 1, 0])
        // 2.5, 2.5, 5: the two tied halves compete for the one leftover unit.
        #expect(ShareAllocator.allocate(10, weights: [1, 1, 2]) == [3, 2, 5])
    }

    @Test("Leftover units go to the largest remainders first")
    func largestRemaindersFirst() {
        #expect(ShareAllocator.allocate(1_150, weights: [333, 333, 334]) == [383, 383, 384])
        // 1/3 and 2/3 of a unit: the larger remainder beats the lower index.
        #expect(ShareAllocator.allocate(1, weights: [1, 2]) == [0, 1])
        // 14.29, 28.57, 57.14: only the middle share rounds up.
        #expect(ShareAllocator.allocate(100, weights: [1, 2, 4]) == [14, 29, 57])
    }

    @Test("A zero weight gets nothing while another weight is positive")
    func zeroWeight() {
        #expect(ShareAllocator.allocate(101, weights: [0, 1, 1]) == [0, 51, 50])
        #expect(ShareAllocator.allocate(101, weights: [1, 0, 1]) == [51, 0, 50])
        #expect(ShareAllocator.allocate(2, weights: [0, 0, 1]) == [0, 0, 2])
    }

    @Test("All-zero weights split equally")
    func allZeroWeights() {
        #expect(ShareAllocator.allocate(100, weights: [0, 0, 0]) == [34, 33, 33])
        #expect(ShareAllocator.allocate(7, weights: [0]) == [7])
        #expect(ShareAllocator.allocate(0, weights: [0, 0]) == [0, 0])
    }

    @Test("Empty weights give no shares")
    func emptyWeights() {
        #expect(ShareAllocator.allocate(100, weights: []) == [])
        #expect(ShareAllocator.allocate(0, weights: []) == [])
    }

    @Test("A negative total or weight counts as 0")
    func negativeInputs() {
        #expect(ShareAllocator.allocate(-100, weights: [1, 1]) == [0, 0])
        #expect(ShareAllocator.allocate(.min, weights: [1, 1]) == [0, 0])
        #expect(ShareAllocator.allocate(100, weights: [-5, 1]) == [0, 100])
        #expect(ShareAllocator.allocate(100, weights: [.min, 1]) == [0, 100])
        #expect(ShareAllocator.allocate(101, weights: [-1, -1]) == [51, 50]) // all count as 0: equal split
        #expect(ShareAllocator.allocate(-1, weights: []) == [])
    }

    @Test("Large totals and weights allocate exactly where total × weight overflows Int")
    func largeTotalsAndWeights() {
        // A 100 000 000 kr bill (10^10 øre) plus 15%, split by bill portions: about 3.8 × 10^19 per product.
        #expect(11_500_000_000.multipliedReportingOverflow(by: 3_333_333_333).overflow)
        #expect(
            ShareAllocator.allocate(11_500_000_000, weights: [3_333_333_333, 3_333_333_333, 3_333_333_334])
                == [3_833_333_333, 3_833_333_333, 3_833_333_334]
        )
        #expect(
            ShareAllocator.allocate(1_000_000_000_000_000_001, weights: [1_000_000_000, 1_000_000_000, 1_000_000_000])
                == [333_333_333_333_333_334, 333_333_333_333_333_334, 333_333_333_333_333_333]
        )
        #expect(ShareAllocator.allocate(.max, weights: [.max - 1, 1]) == [.max - 1, 1])
        #expect(
            ShareAllocator.allocate(.max, weights: [1, 1])
                == [4_611_686_018_427_387_904, 4_611_686_018_427_387_903]
        )
    }

    @Test("Weights that add up past Int.max still split the total exactly")
    func weightSumOverflow() {
        #expect(ShareAllocator.allocate(300, weights: [.max, .max, .max]) == [100, 100, 100])
        // Halved to fit, the 1 becomes 0; the two halves of Int.max tie, so the lower index gets the odd unit.
        #expect(
            ShareAllocator.allocate(.max, weights: [.max, .max, 1])
                == [4_611_686_018_427_387_904, 4_611_686_018_427_387_903, 0]
        )
    }

    /// One non-negative share per weight, adding up to `total` exactly.
    private func expectExactSplit(_ shares: [Int], of total: Int, count: Int) {
        #expect(shares.count == count)
        #expect(shares.reduce(0, +) == total)
        #expect(shares.allSatisfy { $0 >= 0 })
    }

    /// Each share within 1 minor unit of total × weight / Σweights, in exact Int math:
    /// |share × Σweights − total × weight| < Σweights.
    private func expectProportional(_ shares: [Int], of total: Int, weights: [Int]) {
        let weightSum = weights.reduce(0, +)
        for (share, weight) in zip(shares, weights) {
            #expect(abs(share * weightSum - total * weight) < weightSum)
        }
    }
}

// MARK: - Whole-Unit Round-Up

@Suite("ShareAllocator — Whole-Unit Round-Up")
struct WholeUnitRoundUpTests {

    @Test("Rounds up to a whole unit in every currency", arguments: [
        (250, 300), (300, 300), (0, 0),
        (1, 100), (99, 100), (100, 100), (101, 200), (11_501, 11_600), (99_999_999, 100_000_000),
    ])
    func roundsUp(minorUnits: Int, expected: Int) {
        for currency in Currency.allCases {
            #expect(ShareAllocator.roundedUpToWholeUnit(minorUnits, currency: currency) == expected)
        }
    }

    @Test("The whole unit comes from Currency.fractionDigits")
    func unitFromFractionDigits() {
        for currency in Currency.allCases {
            #expect(
                ShareAllocator.roundedUpToWholeUnit(250, currency: currency)
                    == ShareAllocator.roundedUpToWholeUnit(250, fractionDigits: currency.fractionDigits)
            )
        }
        #expect(ShareAllocator.roundedUpToWholeUnit(250, fractionDigits: 0) == 250)
        #expect(ShareAllocator.roundedUpToWholeUnit(25, fractionDigits: 1) == 30)
        #expect(ShareAllocator.roundedUpToWholeUnit(250, fractionDigits: 3) == 1_000)
        #expect(ShareAllocator.roundedUpToWholeUnit(1_000, fractionDigits: 3) == 1_000)
        #expect(ShareAllocator.roundedUpToWholeUnit(1_001, fractionDigits: 3) == 2_000)
    }

    @Test("A negative amount or scale counts as 0")
    func negativeInputs() {
        #expect(ShareAllocator.roundedUpToWholeUnit(-250, currency: .nok) == 0)
        #expect(ShareAllocator.roundedUpToWholeUnit(.min, currency: .nok) == 0)
        #expect(ShareAllocator.roundedUpToWholeUnit(250, fractionDigits: -1) == 250)
    }

    @Test("Results above Int.max saturate instead of overflowing")
    func saturatesAtIntMax() {
        // Int.max ends in …807, so the last whole unit that fits ends in …800.
        #expect(ShareAllocator.roundedUpToWholeUnit(.max - 99, currency: .nok) == .max - 7)
        #expect(ShareAllocator.roundedUpToWholeUnit(.max - 7, currency: .nok) == .max - 7)
        #expect(ShareAllocator.roundedUpToWholeUnit(.max - 6, currency: .nok) == .max)
        #expect(ShareAllocator.roundedUpToWholeUnit(.max, currency: .nok) == .max)
        // 10^18 fits in Int; 10^19 doesn't.
        #expect(ShareAllocator.roundedUpToWholeUnit(1, fractionDigits: 18) == 1_000_000_000_000_000_000)
        #expect(ShareAllocator.roundedUpToWholeUnit(1, fractionDigits: 19) == .max)
        #expect(ShareAllocator.roundedUpToWholeUnit(0, fractionDigits: 19) == 0)
    }
}
