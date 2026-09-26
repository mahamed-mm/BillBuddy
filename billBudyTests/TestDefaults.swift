import Foundation
@testable import billBudy

/// Gives every `CalculatorViewModel` in a test a `UserDefaults` suite of its own, so no test reads
/// or writes the app's real saved preferences (`UserDefaults.standard`) or another test's, even
/// when Swift Testing runs tests in parallel.
///
/// Keep one in a stored property of each suite that makes view models:
///
///     private let defaults = TestDefaults()
///
/// Swift Testing creates a new suite instance for each test, so each test gets its own
/// `TestDefaults`, and every suite it made is removed when the test ends.
final class TestDefaults {
    private var suiteNames: [String] = []

    /// A view model on a new, empty store (see `makeStore()`).
    func makeViewModel() -> CalculatorViewModel {
        CalculatorViewModel(defaults: makeStore())
    }

    /// A new, empty `UserDefaults` suite with a unique name. View models made on the same store
    /// share their saved preferences, as the app does across launches.
    func makeStore() -> UserDefaults {
        let name = "billBudyTests.\(UUID().uuidString)"
        suiteNames.append(name)
        // `UserDefaults(suiteName:)` is nil only for the app's own domain and the global domain.
        return UserDefaults(suiteName: name)!
    }

    deinit {
        for name in suiteNames {
            UserDefaults.standard.removePersistentDomain(forName: name)
        }
    }
}
