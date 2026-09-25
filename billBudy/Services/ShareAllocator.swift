import Foundation

/// Splits amounts in `Int` minor units (øre, cents) with no `Double` step, so no unit is ever
/// lost or added, and rounds them up to whole units.
///
/// A negative input counts as 0, so every function has a result for every input and never traps.
enum ShareAllocator {
    /// `total` split into one share per weight, in proportion to the weights.
    ///
    /// Largest-remainder method: each share starts as the whole part of total × weight / Σweights,
    /// and the units left over go one each to the largest remainders, ties to the lowest index.
    /// So the shares add up to `total` exactly, and each is within 1 minor unit of its exact
    /// proportion. Equal weights give an even split with the leftover units on the first shares:
    /// `allocate(10_000, weights: [1, 1, 1])` → `[3334, 3333, 3333]`, and
    /// `allocate(1_150, weights: [333, 333, 334])` → `[383, 383, 384]`.
    ///
    /// Empty weights give `[]`, and all-zero weights split equally. Each total × weight is taken
    /// at double width, so large totals and weights can't overflow. Weights that add up to more
    /// than `Int.max`, which bill portions never do, are halved until their sum fits: the shares
    /// still add up to `total`, but can be more than 1 minor unit off.
    static func allocate(_ total: Int, weights: [Int]) -> [Int] {
        guard !weights.isEmpty else { return [] }
        let total = max(0, total)
        var (weights, weightSum) = fittingSum(of: weights.map { max(0, $0) })
        if weightSum == 0 {
            weights = Array(repeating: 1, count: weights.count)
            weightSum = weights.count
        }
        // No weight is above the sum, so no whole part is above `total`, and each fits in `Int`.
        let divisions = weights.map { weightSum.dividingFullWidth(total.multipliedFullWidth(by: $0)) }
        var shares = divisions.map(\.quotient)
        let remainders = divisions.map(\.remainder)
        // The remainders add up to a whole number of weightSums: the leftover units. There are
        // fewer of them than nonzero remainders, so a zero-weight share never gets one.
        let leftover = total - shares.reduce(0, +)
        let byLargestRemainder = remainders.indices.sorted {
            remainders[$0] != remainders[$1] ? remainders[$0] > remainders[$1] : $0 < $1
        }
        for index in byLargestRemainder.prefix(leftover) {
            shares[index] += 1
        }
        return shares
    }

    /// `minorUnits` rounded up to a whole unit of `currency`, which is 10^`currency.fractionDigits`
    /// minor units: 250 → 300, 300 → 300, 0 → 0.
    ///
    /// A negative amount counts as 0, and a result above `Int.max` saturates at `Int.max`.
    static func roundedUpToWholeUnit(_ minorUnits: Int, currency: Currency) -> Int {
        roundedUpToWholeUnit(minorUnits, fractionDigits: currency.fractionDigits)
    }

    /// `minorUnits` rounded up to a multiple of 10^`fractionDigits`: the scale behind
    /// `roundedUpToWholeUnit(_:currency:)`, testable at scales no currency uses yet.
    ///
    /// A negative amount counts as 0, and so does a negative `fractionDigits`. A result above
    /// `Int.max` saturates at `Int.max`.
    static func roundedUpToWholeUnit(_ minorUnits: Int, fractionDigits: Int) -> Int {
        let amount = max(0, minorUnits)
        guard amount > 0 else { return 0 }
        // A whole unit above `Int.max` means the next whole unit is above it too.
        guard let unit = wholeUnit(fractionDigits: fractionDigits) else { return .max }
        let remainder = amount % unit
        guard remainder > 0 else { return amount }
        let (rounded, overflow) = amount.addingReportingOverflow(unit - remainder)
        return overflow ? .max : rounded
    }

    /// `weights` and their sum, with every weight halved until the sum fits in `Int`.
    private static func fittingSum(of weights: [Int]) -> (weights: [Int], sum: Int) {
        var sum = 0
        for weight in weights {
            let (next, overflow) = sum.addingReportingOverflow(weight)
            if overflow { return fittingSum(of: weights.map { $0 / 2 }) }
            sum = next
        }
        return (weights, sum)
    }

    /// One whole unit, 10^`fractionDigits` minor units, or `nil` if it doesn't fit in `Int`.
    private static func wholeUnit(fractionDigits: Int) -> Int? {
        var unit = 1
        for _ in 0..<max(0, fractionDigits) {
            let (next, overflow) = unit.multipliedReportingOverflow(by: 10)
            guard !overflow else { return nil }
            unit = next
        }
        return unit
    }
}
